Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1LYQNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 11:13:47 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:58740 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1LYQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 11:13:44 -0500
Date: Sun, 25 Dec 2011 11:13:20 -0500
From: Alec Moskvin <alecmn@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hid_wiimote: add INPUT_FF_MEMLESS dependency
Message-ID: <20111225161320.GA12841@thinkpad>
References: <1324744926-24793-1-git-send-email-alecmn@gmail.com>
 <CANq1E4Qab2sO2QagwmU-66+kUWhpStxVWawEGX=1HCdrM7bgLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4Qab2sO2QagwmU-66+kUWhpStxVWawEGX=1HCdrM7bgLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sunday 25 December 2011 11:06:58, David Herrmann wrote:
> Hi Alec
> 
> On Sat, Dec 24, 2011 at 5:42 PM, Alec Moskvin <alecmn@gmail.com> wrote:
> > This fixes build error:
> > ...
> > CRC 17a7c33e
> > Kernel: arch/x86/boot/bzImage is ready  (#1)
> >  Building modules, stage 2.
> >  MODPOST 7 modules
> > ERROR: "input_ff_create_memless" [drivers/hid/hid-wiimote.ko]
> > undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >
> > Signed-off-by: Alec Moskvin <alecmn@gmail.com>
> > ---
> >  drivers/hid/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> > index 22a4a05..332c22a 100644
> > --- a/drivers/hid/Kconfig
> > +++ b/drivers/hid/Kconfig
> > @@ -620,6 +620,7 @@ config HID_WIIMOTE
> >        depends on BT_HIDP
> >        depends on LEDS_CLASS
> >        select POWER_SUPPLY
> > +       select INPUT_FF_MEMLESS
> >        ---help---
> >        Support for the Nintendo Wii Remote bluetooth device.
> >
> 
> This fix is already in Jiri's tree. See here:
> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=ef6f41157f3864d9bf42671b2ed66062dcafb72e
> 
> Regards
> David

I wasn't aware of that. Shouldn't it be pushed to the main tree, then?

It's not in 3.2-rc7 (released yesterday), which is why I reported it.

Thanks,
Alec
