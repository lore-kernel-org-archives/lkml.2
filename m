Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2LXRwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 12:52:23 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36213 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXRwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 12:52:20 -0500
Date: Mon, 24 Dec 2012 09:55:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "he, bo" <bo.he@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH V2] output the cpu number  when printking.
Message-ID: <20121224175532.GA15041@kroah.com>
References: <1356316276.2385.7.camel@hebo>
 <50D7CDED.4060308@infradead.org>
 <1356321255.2385.8.camel@hebo>
 <1356325315.2385.74.camel@hebo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1356325315.2385.74.camel@hebo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 01:01:55PM +0800, he, bo wrote:
> From: "he, bo" <bo.he@intel.com>
> 
> We often hit kernel panic issues on SMP machines because processes race
> on multiple cpu. By adding a new parameter printk.cpu, kernel prints
> cpu number at printk information line. It’s useful to debug what cpus
> are racing.

How useful is this really for normal developers?  We complained when
this option was proposed by the ARM developers who were, for the first
time, handling more than one processor and the issues involved with
that.  You are enabling this as a default option, for all developers,
and almost no one will ever need it.

So, if you really want this, don't enable this by default.  Also, go
back and read the old thread about this option and why it was rejeted
previously.

thanks,

greg k-h
