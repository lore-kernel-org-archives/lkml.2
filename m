Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2GKPUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:20:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54463 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab2GKPUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:20:05 -0400
Date: Wed, 11 Jul 2012 10:19:18 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <peter.huewe@infineon.com>
Cc: srajiv@linux.vnet.ibm.com, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Luigi Semenzato <semenzato@google.com>, andi.shyti@gmail.com,
        Bryan Freed <bfreed@chromium.org>
Subject: Re: [PATCH 2/2] CHROMIUM: tpm: tpm_i2c_infineon: Lock the I2C
 adapter for a sequence of requests.
Message-ID: <20120711151918.GB21153@linux.vnet.ibm.com>
References: <1339505034-6400-1-git-send-email-peter.huewe@infineon.com>
 <1339505034-6400-2-git-send-email-peter.huewe@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339505034-6400-2-git-send-email-peter.huewe@infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071115-9360-0000-0000-0000084C662C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter / Bryan,

On Tue, Jun 12, 2012 at 02:43:54PM +0200, Peter Huewe wrote:
> From: Bryan Freed <bfreed@chromium.org>
> 
> This is derived from Peter Huewe's recommended fix:
> 
> On some ChromeOS systems, a TPM sharing the I2C bus with another device
> gets confused when it sees I2C requests to that other device.
> This change locks the I2C adapter for the duration of the full sequence
> of I2C requests the TPM needs to complete.
> 
> smbus_xfer is not supported, but SMBUS is not supported by the original
> driver, either.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
> Signed-off-by: Peter Huewe <peter.huewe@infineon.com>

  I've applied this patch to my tpmdd staging tree [1].

Thanks,
Kent

[1] git://github.com/shpedoikal/linux.git tpmdd-next

