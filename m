Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2DRVtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:49:55 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:34198
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab2DRVtx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:49:53 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz9371I98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3hbe9i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Li Yang-R58472 <r58472@freescale.com>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        Li Yang-R58472 <r58472@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Thread-Topic: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Thread-Index: AQHNHa0stNALJ8ehf0yYSWGNyxqTUw==
Date: Wed, 18 Apr 2012 21:49:48 +0000
Message-ID: <CAOZdJXW7MKSzrY-s=KJ2bz-8RyMFDTnV-Yg1Dy5a+VYndT3qzw@mail.gmail.com>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
	<20120229183436.GA30545@pengutronix.de>
	<20120417142105.GA21802@pengutronix.de>
	<94F013E7935FF44C83EBE7784D62AD3F092D1DC7@039-SN2MPN1-022.039d.mgd.msft.net>
	<20120418103334.GD2232@pengutronix.de>
	<CADRPPNQRLyZK-zjeLUYCZtLe+8HhFzFALCMyPeaCGX+buaf+ug@mail.gmail.com>
In-Reply-To: <CADRPPNQRLyZK-zjeLUYCZtLe+8HhFzFALCMyPeaCGX+buaf+ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [107.22.165.113]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <75AD2FC3A0E25D4894F56ECA09C0D731@mgd.freescale.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 9:44 AM, Li Yang <leoli@freescale.com> wrote:

> We do honor your point and can be flexible on this.  I'm just not sure
> if our policy need to be changed to align with the common sense of the
> community.

It does need to be changed, and we are currently working on changing it.

The patch should be resubmitted without the Copyright statement.

-- 
Timur Tabi
Linux kernel developer at Freescale
