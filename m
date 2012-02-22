Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2BVW6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:58:34 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40758 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045Ab2BVW6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:58:33 -0500
Subject: Re: [PATCH] x86, efi: Fix unaligned access and endian issues
From: Matt Fleming <matt@console-pimps.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20120223093140.3f8ad47252f9f331d355ea57@canb.auug.org.au>
References: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
	 <20120223093140.3f8ad47252f9f331d355ea57@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Feb 2012 22:58:28 +0000
Message-ID: <1329951508.4759.14.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 09:31 +1100, Stephen Rothwell wrote:
>
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au> (cross build only)
> 
> The bzImage from a ARCH=x86_64 defconfig+CONFIG_EFI_STUB cross build is
> in http://ozlabs.org/~sfr/bzImage if you want to attempt to boot it.

Thanks Stephen, this bzImage works fine on my setup.

> One little thing is that those two new functions may we warned about as
> unused if CONFIG_EFI_STUB is not set (I have not done that build yet).

Should be OK because they're static inline (it at least doesn't warn
here).

Peter was talking about exporting unaligned.h for host tools so this
patch will probably go through another iteration anyway.

-- 
Matt Fleming, Intel Open Source Technology Center

