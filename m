Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1FILpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:45:53 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47026 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab1FILpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xODdcsSh0OAJJIrpMaEG+xVifbe3Lk8vof24g4k6S4aV+d+7ISndZ71rdPsI8xbTkS
         Jgb0FmWg4SRMJ4F/xC5nlII47T97ZRGidq8xOoPeIn/qMxEsXmdd6v1/gVNwpg+l9ejK
         eQ8YoCVytSSK96+AxCDYvdIIZGzDi7gT2AsRU=
MIME-Version: 1.0
In-Reply-To: <1307615814.5963.2.camel@t60prh>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
	<20110608101515.9478.67943.stgit@localhost.localdomain>
	<BANLkTikYtLExBTcYAwicjEH=1bQp28WitQ@mail.gmail.com>
	<20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
	<1307615814.5963.2.camel@t60prh>
Date: Thu, 9 Jun 2011 13:45:51 +0200
Message-ID: <BANLkTikvteDhzirKUxDcnD8dykw_00ec=A@mail.gmail.com>
Subject: Re: [PATCH 14/15] gma500: nuke the PSB debug stuff
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 12:36 PM, Dave Airlie wrote:
> On Thu, 2011-06-09 at 09:11 +0100, Alan Cox wrote:
>> On Thu, 9 Jun 2011 03:10:03 +0200
>> Patrik Jakobsson wrote:
>>
>> > Hi Alan
>> >
>> > Just a thought. Shouldn't we use the DRM macros for printing debug info?
>>
>> Linux has perfectly good printing functions and using them means we can
>> use dev_dbg() which supports things like nice runtime switching.
>
> You mean like the drm debug functions runtime switching? that predated
> the kernel ones and nobody ever ported :-)
>
> Though if psb wants to be different to other drm drivers it can lead the
> way, though it'll be a total nightmare for all the people who follow
> documentation on how to debug drm drivers using drm.debug=1,2,4,8. for
> various code paths.

Yes, my concern was about drm.debug and use of all the DRM portability stuff
(like using DRM_IRQ_HANDLED instead of IRQ_HANDLED, etc...)

The portability might not be important at this point but I just wanted to raise
the question so I know what is right / wrong.

Alan, I've been working on the output code but think I've reached a dead end.
I'm up to 20000 lines of changes and it's just a big mess. I'm gonna go for
slowly fixing up the current code instead. I also got my hands on a laptop
with a gma500 so I can test that my changes doesn't break LVDS. Stay tuned.

Thanks
