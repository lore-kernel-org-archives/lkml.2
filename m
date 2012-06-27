Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2F0P1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:27:25 -0400
Received: from antcom.de ([188.40.178.216]:54415 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab2F0PZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:25:33 -0400
Message-ID: <4FEB25E8.5060706@antcom.de>
Date: Wed, 27 Jun 2012 17:25:28 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dwmw2@infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v7] MTD: LPC32xx SLC NAND driver
References: <1339064536-20553-1-git-send-email-stigge@antcom.de> <1340794007.29342.50.camel@sauron.fi.intel.com> <4FEAF90B.5030809@antcom.de> <CAAAP30HemOV9svhVghLTWfZe95=P3CT-H7UsQ=xY6rC8=AfBsA@mail.gmail.com>
In-Reply-To: <CAAAP30HemOV9svhVghLTWfZe95=P3CT-H7UsQ=xY6rC8=AfBsA@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 06/27/2012 02:26 PM, Alexandre Pereira da Silva wrote:
> I think it's best in case of *_raw to use nand base default functions,
> like in the MLC patch.

Problem here (specific for this SLC controller) is that it expects us to
access the data register via 16bit access while the actual data is only
8bit wide.

This can't be done with the default nand functions, neither with the
8bit nor 16bit variant.

Roland

PS: Nevertheless, I will post our SLC driver update series against the
l2-mtd branch.
