Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0LTMg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:36:27 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:59269 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756919Ab0LTMgZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:36:25 -0500
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Date: Mon, 20 Dec 2010 13:35:56 +0100
Subject: RE: [PATCH] mfd: Use dummy_irq_chip for tc3589x
Thread-Topic: [PATCH] mfd: Use dummy_irq_chip for tc3589x
Thread-Index: AcugPr65wHetc+hQQn+wm+I4R555BAAA5qIQ
Message-ID: <CEE6BB42CAD6E947908279175AF8470A075EFE20EB@EXDCVYMBSTM006.EQ1STM.local>
References: <20101220120918.GF11095@sortiz-mobl>
In-Reply-To: <20101220120918.GF11095@sortiz-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Samuel]

> This also converts tc3589x to the new irq API.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
> 
> Linus, this should go through your ux500-core branch as this is where
> the
> tc3589x rename happens.

OK applied and pushed to ux500-core, you can drop this
tc35x stuff off the MFD tree now..

Yours,
Linus Walleij
