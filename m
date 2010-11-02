Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0KBQYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:24:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62407 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0KBQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sEljMutuDoB78oodCrFI2G3hIN+qYZVPF8V4AFNAyZwvmKm4SLs9ofq1q19JYp/kCY
         59Wr0/MPzkIsBr0TsejCK8n+04NAgRLB/kh0JGHbFANee2DLByNlFywFyYuXsl+c12Nh
         tWl7c6EwRPl44I+5TZDVF0VpCMRDLmLZcG/94=
Date: Tue, 2 Nov 2010 09:24:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: Re: drivers/media/IR/ir-keytable.c::ir_getkeycode - 'retval' may be
 used uninitialized
Message-ID: <20101102162429.GB14198@core.coreip.homeip.net>
References: <tkrat.980deadea593e9ed@s5r6.in-berlin.de>
 <201010311518.42998.dmitry.torokhov@gmail.com>
 <AANLkTi=AGWGv2WPuGQ4bF7N4TSAbU5YMjry9beXyvspk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=AGWGv2WPuGQ4bF7N4TSAbU5YMjry9beXyvspk@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 12:04:56PM -0400, Jarod Wilson wrote:
> On Sun, Oct 31, 2010 at 6:18 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Sunday, October 31, 2010 10:51:21 am Stefan Richter wrote:
> >> Commit 9f470095068e "Input: media/IR - switch to using new keycode
> >> interface" added the following build warning:
> >>
> >> drivers/media/IR/ir-keytable.c: In function 'ir_getkeycode':
> >> drivers/media/IR/ir-keytable.c:363: warning: 'retval' may be used uninitialized in this function
> >>
> >> It is due to an actual bug but I don't know the fix.
> >>
> >
> > The patch below should fix it. I wonder if Linus released -rc1 yet...
> 
> Looks like it missed rc1.
> 

Nope, I see it there, 47c5ba53bc5e5f88b5d1bbb97acd25afc27f74eb ;)

-- 
Dmitry
