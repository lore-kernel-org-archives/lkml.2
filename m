Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0IWTSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:18:20 -0400
Received: from kroah.org ([198.145.64.141]:51243 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0IWTST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:18:19 -0400
Date: Thu, 23 Sep 2010 11:00:52 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Hill <joshua.hill@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, linux-acpi@vger.kernel.org, alan@redhat.com,
        "Zhang, Rui" <rui.zhang@intel.com>, torvalds@linux-foundation.org,
        Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [stable] [2.6.35-rc5] hp-wmi patch missed .35 merge window,
 requesting addition to next rc
Message-ID: <20100923180052.GF23040@kroah.com>
References: <AANLkTimOVY+iOOMKhwFfX5Wcw1y_PcvoCCfEcjoPmj3J@mail.gmail.com>
 <20100921190816.e6ca6a72.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921190816.e6ca6a72.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 07:08:16PM -0700, Andrew Morton wrote:
> (cc's added)
> 
> On Tue, 21 Sep 2010 10:23:57 -0700 Josh Hill <joshua.hill@gmail.com> wrote:
> 
> > please cc as i'm unsubscribed
> > as reported in this bug: https://bugzilla.kernel.org/show_bug.cgi?id=15344
> > and the patch: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=751ae808f6b29803228609f51aa1ae057f5c576e
> > 
> > the backlight on this laptop goes down one level whenever
> > /proc/acpi/ac_adapter/*/status is read.
> > i've been told the patch missed the .35 merge window, and is going to
> > be in .36, but ubuntu is
> > going to release 10.10 soon with .35 in it, and if this patch doesn't
> > make it into .35 my laptop
> > will be doing this for its (10.10) entire lifetime. i didn't know who
> > to really contact and request this sort
> > of thing so i'm doing it here.
> 
> The suggestion is that mainline's
> 751ae808f6b29803228609f51aa1ae057f5c576e ("x86 platform drivers: hp-wmi
> Reorder event id processing") be backported into 2.6.35.x to fix the
> post-2.6.32 regression described in
> https://bugzilla.kernel.org/show_bug.cgi?id=15344

Now applied.

thanks,

greg k-h
