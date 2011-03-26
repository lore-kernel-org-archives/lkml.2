Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1CZCa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 22:30:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64012 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab1CZCay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vkkMGfCjDI5nnouCkrS3Vm6tyDO8dZVMhdrcNQnzELys03jJuNomkhraX28DfswQeA
         5gzQzd+4TGz5sAss30Mx7+gSsxTEJX5ZAw5d3QxNQhHhdIn0JukWS1llM1RV+GlQ6Rrw
         WQQ49rZ+1xT7F7UtN9hSRSrXuM9gU9Wlt00NQ=
Date: Sat, 26 Mar 2011 10:21:48 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Peter H??we <PeterHuewe@gmx.de>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, trivial@kernel.org,
        jkosina@suse.cz, joe@perches.com
Subject: Re: [PATCH] staging/trivial: Fix common spelling mistakes
Message-ID: <20110326022147.GA4758@gmail.com>
Mail-Followup-To: Peter H??we <PeterHuewe@gmx.de>, greg@kroah.com,
	linux-kernel@vger.kernel.org, trivial@kernel.org, jkosina@suse.cz,
	joe@perches.com
References: <alpine.LNX.2.00.1103141259500.19969@pobox.suse.cz>
 <1300139875-8688-1-git-send-email-peterhuewe@gmx.de>
 <20110315031418.GB3372@gmail.com>
 <201103260239.23708.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103260239.23708.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 02:39:23AM +0100, Peter H??we wrote:
> Am Dienstag 15 M?rz 2011, 04:14:20 schrieb Harry Wei:
> > > This patch fixes some very common spelling mistakes in drivers/staging
> > Hi peter,
> >      I have sense that you should split this
> > patch for patches, which one patch just do
> > one spelling mistakes.
> > 
> > But there are so many spelling mistakes.
> > I wanna help you with this stuff. Would you
> > like to assign some to me. I am so pleasure
> > for this.
> 
> 
> Hi Harry,
> 
> (sorry for my late reply)
That's all right :)
> 
> thanks for you help and I really appreciate your offer.
> I've split up the patch for the staging directory into 27 patches, one for 
> each affected directory, since this was the easiest way to split my big old 
> patch ;)
You are great ;)
> 
> As you know there's still the big "fix common spelling mistakes" patch for the 
> trivial tree (i.e. everything but the staging directory) which is still 
> pending, and probably won't apply anymore ;)
> So it might be a good idea to split this one up as well, and for this your 
> help comes handy.
I'd love to.
> 
> If this is fine with Jiri I'd suggest this splitting:
> 
> One patch each for:
> arch/
> crypto/
> fs/
> include/
> kernel/
> lib/
> mm/
> net/
> scripts/
> security/
> sound/
> 
> And for drivers/ one patch for each subsystem/directory,
> with the exception of drivers/media/ - this one I'd split into 
> media/dvb/
> media/video/
> and the remaining media
This is okay for me.
> 
> 
> If you want to help me the easiest way would be that I update the patch to the 
> current trivial tree and then send it to you, you apply it with patch (not git 
> am) and then commit each subdirectory and write a nice commit message  and 
> send it to the list ;) 
Okay, i'd like to do it anytime.
> 
> But I'd like to hear Jiri's opinion first.
Okay, i am waiting for your message.

Thanks.
Best Regards.
Harry Wei.
> 
> 
> Thanks,
> Peter
> 
