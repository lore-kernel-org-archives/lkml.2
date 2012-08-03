Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2HCHmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:42:08 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:49166 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2HCHmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:42:05 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jmorris@namei.org>, <key@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>, <bfreed@chromium.org>,
        <safford@linux.vnet.ibm.com>, <hpa@linux.intel.com>
Subject: RE: New TPM driver, hwrng driver and fixes (2)
Thread-Topic: New TPM driver, hwrng driver and fixes (2)
Thread-Index: AQHNbpc1DVjIzAUkL02PwljT+R8mVpdHZaIAgAABJoCAAFC44A==
Date: Fri, 3 Aug 2012 07:42:00 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440E0A49@MUCSE501.eu.infineon.com>
References: <20120730210522.GA23790@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208031440210.25196@tundra.namei.org>
 <alpine.LRH.2.02.1208031444100.25196@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1208031444100.25196@tundra.namei.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

>Reverted:
>  CC [M]  drivers/char/tpm/tpm_i2c_infineon.o
>drivers/char/tpm/tpm_i2c_infineon.c:740: error: lvalue required as unary & operand
>make[1]: *** [drivers/char/tpm/tpm_i2c_infineon.o] Error 1

>Was this code tested?

Yes - quite extensively and also reviewed quite extensively.

I'll have a look at this - probably the case if CONFIG_PM is not set is causing this.
Sorry for the inconvenience, I'll create a patch.

Peter



