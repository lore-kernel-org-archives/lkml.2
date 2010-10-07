Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0JGV7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:59:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34519 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JGV7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vyNPPMNFuHuwmLMN6xE6cRjMHBQ2QWTFxGD8fPNdmssZkcvY7rb8YqENb2xpKzD63d
         KETLxylzb5CEHSLgZS8Y6shdvdvi5DcTVkJGpZHtrYspvMlUxVOo9ML8z/gMOy1r7j0N
         Rtp5+t1BuyzkwgFjocOnr9mQ/YJlIL2Hzss/E=
Date: Thu, 7 Oct 2010 14:58:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mario Limonciello <superm1@ubuntu.com>,
        Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
Message-ID: <20101007215854.GC18628@core.coreip.homeip.net>
References: <20101007111510.GA19624@srcf.ucam.org>
 <AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
 <20101007133529.GA21782@srcf.ucam.org>
 <AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com>
 <20101007205049.GB32726@srcf.ucam.org>
 <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
 <20101007213027.GA18628@core.coreip.homeip.net>
 <20101007213754.GA1896@srcf.ucam.org>
 <20101007214628.GB18628@core.coreip.homeip.net>
 <20101007215028.GB2292@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007215028.GB2292@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 10:50:28PM +0100, Matthew Garrett wrote:
> On Thu, Oct 07, 2010 at 02:46:28PM -0700, Dmitry Torokhov wrote:
> > On Thu, Oct 07, 2010 at 10:37:54PM +0100, Matthew Garrett wrote:
> > > Dell laptop driver is reasonable. All we need is a list of hardware, and 
> > > I'd really hope that Dell know which BIOS versions contain this code!
> > > 
> > 
> > Unfortunately this kind of crap tends to flow from one BIOS version to
> > another.. How many DMI entries do we know about so far? Did Dell issue
> > firmware updates correcting the issue so new boxes will not exhibit the
> > problem?
> 
> Pushing this out to userspace doesn't help. If it's sufficiently 
> prevelant that it's impossible to have a comprehensive list, then a 
> module option makes it too easy for people to just post the fix on a 
> forum somewhere and never actually get it upstream.
> 

Forcing users patching the kernel reduces chances that it will be fixed
at all. Also there is load of patches that never make into distributions
and even less in mainline. Or if they make it it takes looong time...
so I do not think it is a valid argument here.

-- 
Dmitry
