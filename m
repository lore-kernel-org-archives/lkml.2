Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0JAAvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:51:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:58436 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab0JAAvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:51:22 -0400
Date: Fri, 1 Oct 2010 10:51:17 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, joe@perches.com, christophe-h.ricard@st.com
Subject: Re: [PATCH 1/3] TPM: new stm i2c device driver
In-Reply-To: <e828eb98bf5b36fea2bd89760d7bc3cf3d5b6755.1285870690.git.srajiv@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1010011049370.32042@tundra.namei.org>
References: <cover.1285870690.git.srajiv@linux.vnet.ibm.com> <e828eb98bf5b36fea2bd89760d7bc3cf3d5b6755.1285870690.git.srajiv@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
