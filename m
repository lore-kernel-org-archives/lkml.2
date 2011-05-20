Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab1ETPV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:21:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49252 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab1ETPV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TXM6gzoxRAUwAs3oq9oFiAFHzOoq5CUw0smo43EMstjHUJAj6fmLrGqIceLj5xfm97
         pHp2QvMCFL/TRSd9VKk0l2qtQ5UKv7/f2uTJ89OWfZUEVvounE50AnGG+oQY7+mzOHx/
         /CLuWY6X0oPepwv9PphiNiLiKLA0ijNRsQMXg=
Date: Fri, 20 May 2011 19:21:18 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net, dmitry.torokhov@gmail.com
Subject: Re: [PATCH] olpc_battery: bind to device tree
Message-ID: <20110520152118.GA10699@oksana.dev.rtsoft.ru>
References: <20110219150644.681D59D401D@zog.reactivated.net>
 <AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 01:34:30PM -0700, Grant Likely wrote:
> [cc'ing devicetree-discuss@lists.ozlabs.org.  Please cc this list for
> any dt-related patches]
> 
> On Sat, Feb 19, 2011 at 8:06 AM, Daniel Drake <dsd@laptop.org> wrote:
> > Move from being statically probed by platform presence to binding to
> > the battery node of the device tree.
> >
> > This is cleaner and allows suspend/resume (wakeup) support to be added
> > in a later patch.
> >
> > Signed-off-by: Daniel Drake <dsd@laptop.org>
> 
> Hi Daniel, comments below.

Daniel,

I just wondering what happened with this patch?..

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
