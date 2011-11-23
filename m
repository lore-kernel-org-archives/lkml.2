Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1KWOe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:34:57 -0500
Received: from portal.weinmann.de ([62.8.140.122]:57910 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1KWOe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:34:56 -0500
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Carsten Behling'" <carsten.behling@garz-fricke.com>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 15:34:42 +0100
Subject: RE: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: AcypMG7f1j3pt+VZTlOvrrSAA2wmYwAAZ+ewACQAp5AAAcQnEAACUzcAAAZ8sxA=
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B44FC83@wm021.weinmann.com>
References: <D99582E5322435468A77E74BB0039E7B1D1655BF4D@SRV02.hamburg.garz-fricke.de>
 <EF2E73589CA71846A15D0B2CDF79505D087B40D16B@wm021.weinmann.com>
 <D99582E5322435468A77E74BB0039E7B1D1655BFBB@SRV02.hamburg.garz-fricke.de>
 <EF2E73589CA71846A15D0B2CDF79505D087B40D349@wm021.weinmann.com>
 <D99582E5322435468A77E74BB0039E7B1D1655C047@SRV02.hamburg.garz-fricke.de>
In-Reply-To: <D99582E5322435468A77E74BB0039E7B1D1655C047@SRV02.hamburg.garz-fricke.de>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carsten,

Carsten Behling wrote on 2011-11-23:
> I think it must be:
> 
> +		for (i = 0; i < msg->len; ++i) {
> +			internal_address |= ((unsigned)msg->buf[msg->len-1-i]) << (8 * i);
> +			int_addr_flag += AT91_TWI_IADRSZ_1;
> +		}
> +		at91_twi_write(dev, AT91_TWI_IADR, internal_address);

yes, I think you're right. I tested only with 8 bit addresses
(msg->len = 1), so I haven't seen this error.

I will modify the patch and post it later today.

Thanks for this feedback,
Niko

