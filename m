Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab0JAO2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:28:04 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:54518 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151Ab0JAO2C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:28:02 -0400
From: Christophe Henri RICARD <christophe-h.ricard@st.com>
To: James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>
Date: Fri, 1 Oct 2010 16:27:14 +0200
Subject: RE: [PATCH 1/3] TPM: new stm i2c device driver
Thread-Topic: [PATCH 1/3] TPM: new stm i2c device driver
Thread-Index: ActhAsRuzjIc24maTcC2qxuk3BDmXgAcb0Ow
Message-ID: <0B9F1C5B86169C4EA9D042C251022E49105CEE8F7E@SAFEX1MAIL3.st.com>
References: <cover.1285870690.git.srajiv@linux.vnet.ibm.com>
 <e828eb98bf5b36fea2bd89760d7bc3cf3d5b6755.1285870690.git.srajiv@linux.vnet.ibm.com>
 <alpine.LRH.2.00.1010011049370.32042@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1010011049370.32042@tundra.namei.org>
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

Hi James,

Which kernel are you using ?
I have made my testing with a 2.6.35.4 kernel.
As far as I know kernel 2.6.36 will not provide any ioctl field any more.
May be this is the reason ?

Please let me know.
Thanks
Christophe

-----Original Message-----
From: James Morris [mailto:jmorris@namei.org] 
Sent: Thursday, September 30, 2010 7:51 PM
To: Rajiv Andrade
Cc: linux-kernel@vger.kernel.org; joe@perches.com; Christophe Henri RICARD
Subject: Re: [PATCH 1/3] TPM: new stm i2c device driver

On Thu, 30 Sep 2010, Rajiv Andrade wrote:

> From: Christophe Henri RICARD <christophe-h.ricard@st.com>
> 
> This driver uses the Linux I2C, TPM and generic gpio interfaces.
> 
> Signed-off-by: Christophe Henri RICARD <christophe-h.ricard@st.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

This does not look to have been compile tested against my tree:

 CC [M]  drivers/char/tpm/tpm_stm_st19_i2c.o
drivers/char/tpm/tpm_stm_st19_i2c.c:574: error: unknown field ioctl specified in initializer
drivers/char/tpm/tpm_stm_st19_i2c.c:574: warning: initialization from incompatible pointer type
make[1]: *** [drivers/char/tpm/tpm_stm_st19_i2c.o] Error 1

The locked ioctl was removed in commit
b19dd42faf413b4705d4adb38521e82d73fa4249



- James
-- 
James Morris
<jmorris@namei.org>
