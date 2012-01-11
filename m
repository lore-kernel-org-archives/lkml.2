Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2AKJ2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:28:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54814 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab2AKJ2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120110135147.GB26599@S2101-09.ap.freescale.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-4-git-send-email-b29396@freescale.com>
	<20120108130542.GC2203@richard-laptop>
	<20120109020848.GF1835@S2101-09.ap.freescale.net>
	<20120109021702.GV2414@b20223-02.ap.freescale.net>
	<20120109063136.GI1835@S2101-09.ap.freescale.net>
	<20120110083842.GA2414@b20223-02.ap.freescale.net>
	<CACRpkdZ=G+=Aq49r9VYa1ZGMg=Sy3Dy3kHNbbcFRp-Hn6y1ZqQ@mail.gmail.com>
	<20120110135147.GB26599@S2101-09.ap.freescale.net>
Date: Wed, 11 Jan 2012 10:28:43 +0100
Message-ID: <CACRpkdbUX-s8hM_Gk=XiwUufAzGz479L_t8vg77ek1KwPCKa_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Richard Zhao <richard.zhao@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, w.sang@pengutronix.de, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        shawn.guo@freescale.com, kernel@pengutronix.de, cjb@laptop.org,
        Dong Aisheng <b29396@freescale.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 2:51 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Jan 10, 2012 at 11:43:28AM +0100, Linus Walleij wrote:
>> What we need to know right now is what you need from the pin
>> controller core to do that. We have a (custom) pinconf API now,
>> does it fit the bill?
>>
> Hmm, I do not think it fits right away, as I do not think it's sensible
> to have pinctrl client drivers call pin_config_set() directly.

OK that's more or less what Stephen said too so I'm cooking a
config table ala pinmux with string identifiers.

>> I have spent some time on generic pin config, it was not much
>> commented so if it helps you please ACK the patches.
>>
> Since the ARM community is the one who is most interested in pinctrl
> subsystem so far, I guess copying LAKML will help collect more comments
> and various tags.  (For example, I'm interested in pinctrl, but I do
> not track LKML as close as I do for LAKML).

True. I'll fix that.

>> Next from discussions with Stpehen I've sort of figured out that
>> we need a config mapping table of sorts and then a means to activate
>> entries of that table at runtime. I'm trying to come up with something
>> for this.
>>
> That's something we are waiting for pinconf being usable for imx.

I'll fix something, please review when it appears!

Thanks,
Linus Walleij
