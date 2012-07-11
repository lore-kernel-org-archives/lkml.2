Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2GKPR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:17:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41581 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab2GKPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:17:25 -0400
Date: Wed, 11 Jul 2012 10:16:51 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <peter.huewe@infineon.com>
Cc: srajiv@linux.vnet.ibm.com, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Luigi Semenzato <semenzato@google.com>, andi.shyti@gmail.com
Subject: Re: [PATCH 1/2] char/tpm: Add new driver for Infineon I2C TIS TPM
Message-ID: <20120711151651.GA21153@linux.vnet.ibm.com>
References: <1339505034-6400-1-git-send-email-peter.huewe@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339505034-6400-1-git-send-email-peter.huewe@infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071115-5806-0000-0000-0000173075E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Jun 12, 2012 at 02:43:53PM +0200, Peter Huewe wrote:
> This patch adds a driver to support Infineon's SLB 9635 TT 1.2 Soft I2C TPMs
> which follow the TGC TIS 1.2 TPM specification[1] and Infineon's I2C Protocol
> Stack Specification 0.20.
> The I2C Protocol Stack Specification is a simple adaption of the LPC TIS
> Protocol to the I2C Bus.
> The I2C TPMs can be used when LPC Bus is not available (i.e. non x86
> architectures like ARM).
> 

  I've applied this patch to my tpmdd staging tree [1].

Thanks,
Kent

[1] git://github.com/shpedoikal/linux.git tpmdd-next

