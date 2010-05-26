Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0EZInW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:43:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:43108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab0EZInU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:43:20 -0400
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu, James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <201005252344.37639.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	 <201005252344.37639.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 10:42:21 +0200
Message-ID: <1274863341.5882.4849.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 23:44 +0200, Rafael J. Wysocki wrote:
> 
> No, I don't really think it's going to be a small change.  The problem is that
> for the Android people changing user space is very hard, so I don't think
> this realy is an option, given that they would have to implement it themselves,
> test it, validate it on multiple different hardware platforms etc. and _then_
> resubmit the feature without any guarantee that it will be merged. 

So your position is basically that we're going to merge this stuff
because google doesn't want to expend effort into investigating a
potential saner solution?

So why don't we simply merge all the crap people throw at us and be done
with it.
