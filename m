Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0HNS3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 14:29:25 -0400
Received: from mail001.aei.ca ([206.123.6.130]:49259 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab0HNS3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 14:29:24 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35.2
Date: Sat, 14 Aug 2010 14:27:03 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.2-crc+; KDE/4.4.5; x86_64; ; )
Cc: sedat.dilek@gmail.com, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, penberg@kernel.org, arthur@psw.ro,
        wylda@volny.cz
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com> <AANLkTikNTZSqZ-sa0uGY0FnjDnOziu4qR8fEitD2TPQc@mail.gmail.com> <AANLkTi=TNsb_JaP0_us8C0XQwRK3qaUdviA-YxcwT223@mail.gmail.com>
In-Reply-To: <AANLkTi=TNsb_JaP0_us8C0XQwRK3qaUdviA-YxcwT223@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008141427.03946.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 August 2010 13:31:11 Linus Torvalds wrote:
> On Sat, Aug 14, 2010 at 10:27 AM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
> >
> > Only to clarify, your new single patch replaces...???
> >
> > mm: fix missing page table unmap for stack guard page failure case
> > mm: keep a guard page below a grow-down stack segment
> 
> No, not replaces. It goes on top of them.

Hi,

It seems to be helping here.  Without it 35.2 would either stall in boot or give lots of tracebacks.  With it things
start normally and my background stuff works as expected.

I have the drm-core-next tree, andrea's transparent huge page support-29, a patch to let xconfig work with qt4,
and one to help em28xx from having problems during startup on top of 35.2

Thanks,
Ed Tomlinson
