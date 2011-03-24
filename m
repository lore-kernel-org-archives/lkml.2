Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1CXLqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:46:55 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:43990 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917Ab1CXLqx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:46:53 -0400
X-Greylist: delayed 73150 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 07:46:52 EDT
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>, Greg KH <gregkh@suse.de>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Date: Thu, 24 Mar 2011 12:45:54 +0100
Subject: RE: [PATCH 2/2] mach-ux500: Add CG2900 devices
Thread-Topic: [PATCH 2/2] mach-ux500: Add CG2900 devices
Thread-Index: Acvpg4NTx/P3PPlsTe+VYaoVS3uQKwAlPduw
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C52AB89@EXDCVYMBSTM005.EQ1STM.local>
References: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<20110323142719.GA17369@suse.de>
 <AANLkTikZD5qie4y=tRpZXuea9D+_vDSGLMr+20p_PVkC@mail.gmail.com>
In-Reply-To: <AANLkTikZD5qie4y=tRpZXuea9D+_vDSGLMr+20p_PVkC@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > As this touches ARM specific code, I need an ack from the ARM
> maintainer
> > before I can take this through the staging tree.  Is there any way to
> > make it part of your drivers/staging/ submission?  There are other
> > examples in the staging tree already that do this, why not do that
> here
> > as well?
> 
> Hm yeah maybe it's possible if you move devices-cg2900.*
> to staging/cg2900, then split off the stuff in board-mop500.c into
> some drivers/staging/cg2900/board-mop500-cg2900.c which
> adds the device in some proper initcall.
> 
> Do you think it can be done P-G? I might have overestimated
> the work involved in moving that stuff to /staging.
> 
> Yours,
> Linus Walleij

As Arnd requested yesterday, I can move most of devices-cg2900, maybe all,
to the staging folder (probably to cg2900_lib.c). I will then minimize
whatever is needed in board-mop500.c. I will see what I can do.

Thanks,
/P-G
