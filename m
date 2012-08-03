Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab2HCEpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:45:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:57150 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2HCEpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:45:14 -0400
Date: Fri, 3 Aug 2012 14:45:03 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>, hpa@linux.intel.com
Subject: Re: New TPM driver, hwrng driver and fixes (2)
In-Reply-To: <alpine.LRH.2.02.1208031440210.25196@tundra.namei.org>
Message-ID: <alpine.LRH.2.02.1208031444100.25196@tundra.namei.org>
References: <20120730210522.GA23790@linux.vnet.ibm.com> <alpine.LRH.2.02.1208031440210.25196@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012, James Morris wrote:

> On Mon, 30 Jul 2012, Kent Yoder wrote:
> 
> > Hi James,
> > 
> > The following changes since commit 663728418e3494f8e4a82f5d1b2f23c22d11be35:
> 
> Pulled to 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Reverted:
  CC [M]  drivers/char/tpm/tpm_i2c_infineon.o
drivers/char/tpm/tpm_i2c_infineon.c:740: error: lvalue required as unary & operand
make[1]: *** [drivers/char/tpm/tpm_i2c_infineon.o] Error 1


Was this code tested?

-- 
James Morris
<jmorris@namei.org>
