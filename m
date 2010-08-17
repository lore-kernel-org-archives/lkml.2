Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab0HQQZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:25:41 -0400
Received: from waste.org ([173.11.57.241]:48090 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757866Ab0HQQZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:25:40 -0400
Subject: Re: [PATCH] Export mlock information via smaps
From: Matt Mackall <mpm@selenic.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <201008171039.31070.knikanth@suse.de>
References: <201008171039.31070.knikanth@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:25:36 -0500
Message-ID: <1282062336.10679.226.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 10:39 +0530, Nikanth Karthikesan wrote:
> Currently there is no way to find whether a process has locked its pages in
> memory or not. And which of the memory regions are locked in memory.
> 
> Add a new field to perms field 'l' to export this information. The information
> exported via maps file is not changed.

I'm worried that your new 'l' flag will fatally surprise some naive
parser of this file.

-- 
Mathematics is the supreme nostalgia of our time.


