Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab2GRE1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:27:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36464 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2GRE1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:27:07 -0400
Message-ID: <1342585616.28942.2.camel@phoenix>
Subject: Re: [PATCH RFT 2/2] regulator: palmas: Convert palmas_ops_ldo to
 [get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 18 Jul 2012 12:26:56 +0800
In-Reply-To: <1342583395.12515.6.camel@phoenix>
References: <1342583289.12515.4.camel@phoenix>
	 <1342583395.12515.6.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2012-07-18 於 11:49 +0800，Axel Lin 提到：
> Also remove palmas_ldo_write() function because it is not used after this
> conversion.

Oh. Just found another issue in current code.
Current code in palmas_ldo_init() calls palmas_smps_[read|write]
is wrong. It should call palmas_ldo_[read|write] instead.
And this means palmas_ldo_write() cannot be removed.

To make it easier for review, I'll resend the patches for palmas
as a serial.

Regards,
Axel

