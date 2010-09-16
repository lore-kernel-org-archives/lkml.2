Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0IPM7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:59:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43654 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0IPM7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ToNuS86XJ9OX9ApKlMqYQDYVFpzTv60qdik5ydftk1veE9TDDTNs+JWeFBdH8vEkbo
         7E6yGua11PA8w9nxqFeP1BCeSpltN8z/Xe6b+07NGu3VfSu4x6gClUJj3JP0zb7+2Cvs
         ytvwfCeycaC0DI0CAR9QrYPdLWL5I0AE22Q/Q=
Date: Thu, 16 Sep 2010 16:59:08 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/14] staging: ath6kl: check return code of get_user
 and put_user
Message-ID: <20100916125908.GA4491@albatros>
References: <1283711550-7246-1-git-send-email-segooon@gmail.com>
 <35B17FE5076C7040809188FBE7913F983F2381DB98@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F2381DB98@SC1EXMB-MBCL.global.atheros.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 22:59 -0700, Vipin Mehta wrote:
> Hi Vasiliy,
>     You mentioned in your email that you were unable to compile the driver. Can you pls reproduce a log of the errors you observed?

vasya@albatros:~/linux$ make allyesconfig && make drivers/staging/ath6kl/
  HOSTCC  scripts/kconfig/conf.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --allyesconfig arch/x86/Kconfig
#
# configuration written to .config
#
scripts/kconfig/conf --silentoldconfig arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  LD      drivers/staging/ath6kl/built-in.o

I think there should be more CC ath6kl/*.o lines :)


Thanks,
-- 
Vasiliy
