Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2HONEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:04:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2HONES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:04:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 15/31] arm64: SMP support
Date: Wed, 15 Aug 2012 13:04:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-16-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-16-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151304.14585.arnd@arndb.de>
X-Provags-ID: V02:K0:U96kSHLVWQEbI2y7ASKamUyaEmQ3nDC7kEtDRAFpZx4
 S6qel86DgKCI4dye/cOGisIencAkX1vf8DNq5w9kDY3td+823S
 WZtSOesavbFNCH3rz2W0vXB0KmzGERRg7IX6VhL5K4OFW3TxMY
 DOV0AoK6a+fyu3Tedafy60krXPPrSdvMA+OzoxtUAdeFhEJ9kd
 tnIY/WuGzgi1skRg78C/qflElJNSLbqCVW6h6EasbPul4SHOsx
 NyskY+cYAsgG9uIpOuxl0x5sqq2SOE17BZPEbGEHo0R2gKiUIJ
 z3vxacQmdQWe6Yx9gTB51GQzg4yYgt6UsCAMccwuYGv5gWOSFW
 8QLLpqqYA13ry/kgyhws=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> This patch adds SMP initialisation and spinlocks implementation for
> AArch64. The spinlock support uses the new load-acquire/store-release
> instructions to avoid explicit barriers. The architecture also specifies
> that an event is automatically generated when clearing the exclusive
> monitor state to wake up processors in WFE, so there is no need for an
> explicit DSB/SEV instruction sequence. The SEVL instruction is used to
> set the exclusive monitor locally as there is no conditional WFE and a
> branch is more expensive.
> 
> For the SMP booting protocol, see Documentation/arm64/booting.txt.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
