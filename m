Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2HXIdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:33:32 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:18094 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2HXId1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:33:27 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jmorris@namei.org>, <key@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>, <adlai@linux.vnet.ibm.com>,
        <xiaoyan.zhang@intel.com>, <jj@chaosbits.net>
Subject: RE: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Thread-Topic: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Thread-Index: AQHNgLBwseNda/zV6EGrO8CD/jLRy5dnufyAgADXl6CAABF4gA==
Date: Fri, 24 Aug 2012 08:32:47 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440E13FD@MUCSE501.eu.infineon.com>
References: <20120822215216.GC13519@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208240632120.25506@tundra.namei.org> 
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

>> From: James Morris [mailto:jmorris@namei.org] 
>> I'm getting this error when building i2c as a module
>> WARNING: "__i2c_transfer" [drivers/char/tpm/tpm_i2c_infineon.ko] undefined!

> This is unconditionally (except I2C) available in Linus' master tree.
> And was introduced by b37d2a3a75cb in June by Jean Delvare.

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b37d2a3a75cb0e72e18c29336cb2095b63dabfc8

> It was tested here against Linus' tree at time of submission.

Did double check it against v3.6-rc3.
$ make ARCH=arm omap2plus_defconfig
$ make ARCH=arm menuconfig
-> deselected OMAP2_TYPICAL, which enables I2C to be builded as a module.
-> selected I2C as Module.
Build using make -> no error.

Thanks,
Peter



