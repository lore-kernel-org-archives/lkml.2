Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030327Ab2HWKl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:41:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429Ab2HWKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:41:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCHv4 0/9] *** ARM: Update arch-vt8500 to Devicetree ***
Date: Thu, 23 Aug 2012 10:40:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org
References: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231040.16702.arnd@arndb.de>
X-Provags-ID: V02:K0:uiYTJxY8GD6UnY+c63xdhJu4GntB93VDwfBt8Brbcxw
 bW76gvxG+22+6A1+Wza5CmJQMTInLjl/b0i2gG2l4R8e1K6v6H
 Bs/20ODjKIXtnRY8uPd4i/gdraH1ggNgae2dznU0V68GKnU0RP
 0GEe9V/qPgtyAPtD/4RtS+s3uabRVS2cJCO4kdLf0IKoVohO1F
 N9KSLXwbMSfl6IzkE+EXJli3xPJtu4nidENliLE0YAeIoIFCIT
 Aov3sfA4ccFp2J6UD2NM5ArzNqr+Fr6PnTLjpdIyGT4KaIgTeE
 PeVk7UkxBQmZTF3n2f4HNOBO0BSrASNj1f7FOFpb9/Ncg4XFj7
 3fRApW5E4L1yVo+ezlg0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012, Tony Prisk wrote:
> Patchset based on Arnd's arm-soc/for-next branch.
> 
> 
> Could I get this reviewed, hopefully for inclusion into v3.7.

I can take them into the arm-soc tree if there are no new comments.
For the last two patches, you need to get an Acked-by comment from the
gpio and clk maintainers, respectively, or you should send them
the patches for inclusion in those subsystem trees.

	Arnd
