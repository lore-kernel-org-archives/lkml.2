Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2C0WkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:40:03 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:48988 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab2C0WkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:40:00 -0400
Message-ID: <1332887999.2040.13.camel@shrek.rexursive.com>
Subject: Re: [PATCH v5]: Hibernation: lower/better control the amount of
 pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Wed, 28 Mar 2012 09:39:59 +1100
In-Reply-To: <201203280041.55043.rjw@sisk.pl>
References: <1332887486.2040.10.camel@shrek.rexursive.com>
	 <201203280041.55043.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 00:41 +0200, Rafael J. Wysocki wrote:
> If you define a macro, please use capital letters in the name.  Also,
> the parentheses aren't necessary I think.
> 
> Perhaps it would be better to use a static inline function instead? 

Hmm, was just following the nr_free_pages() definition in swap.h:

/* Definition of global_page_state not available yet */
#define nr_free_pages() global_page_state(NR_FREE_PAGES)

Still no good?

-- 
Bojan

