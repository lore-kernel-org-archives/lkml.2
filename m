Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1HWGhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:37:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1HWGhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:37:20 -0400
Subject: Re: [PATCH] defconfig: Build virtio paravirtualization features by
 default
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
In-Reply-To: <1313320581-7050-1-git-send-email-levinsasha928@gmail.com>
References: <1313320581-7050-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 23 Aug 2011 09:35:57 +0300
Message-ID: <1314081357.3668.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Sun, 2011-08-14 at 14:16 +0300, Sasha Levin wrote:
> This patch adds guest paravirtualization config options to defconfig.
> 
> The purpose is to allow defconfig kernels to run well in a virtualized
> environment.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  arch/x86/configs/i386_defconfig   |   11 +++++++++++
>  arch/x86/configs/x86_64_defconfig |   11 +++++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
> index 2bf18059f..3287152 100644
> --- a/arch/x86/configs/i386_defconfig
> +++ b/arch/x86/configs/i386_defconfig
> @@ -337,3 +337,14 @@ CONFIG_SECURITY_SELINUX_DISABLE=y
>  CONFIG_CRYPTO_AES_586=y
>  # CONFIG_CRYPTO_ANSI_CPRNG is not set
>  CONFIG_CRC_T10DIF=y
> +CONFIG_VIRTIO=y
> +CONFIG_VIRTIO_RING=y
> +CONFIG_VIRTIO_PCI=y
> +CONFIG_VIRTIO_BLK=y
> +CONFIG_VIRTIO_NET=y
> +CONFIG_NET_9P=y
> +CONFIG_NET_9P_VIRTIO=y
> +CONFIG_9P_FS=y
> +CONFIG_VIRTIO_BALLOON=y
> +CONFIG_VIRTIO_CONSOLE=y
> +CONFIG_HW_RANDOM_VIRTIO=y
> diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
> index 22a0dc8..1ee0e99 100644
> --- a/arch/x86/configs/x86_64_defconfig
> +++ b/arch/x86/configs/x86_64_defconfig
> @@ -336,3 +336,14 @@ CONFIG_SECURITY_SELINUX_BOOTPARAM=y
>  CONFIG_SECURITY_SELINUX_DISABLE=y
>  # CONFIG_CRYPTO_ANSI_CPRNG is not set
>  CONFIG_CRC_T10DIF=y
> +CONFIG_VIRTIO=y
> +CONFIG_VIRTIO_RING=y
> +CONFIG_VIRTIO_PCI=y
> +CONFIG_VIRTIO_BLK=y
> +CONFIG_VIRTIO_NET=y
> +CONFIG_NET_9P=y
> +CONFIG_NET_9P_VIRTIO=y
> +CONFIG_9P_FS=y
> +CONFIG_VIRTIO_BALLOON=y
> +CONFIG_VIRTIO_CONSOLE=y
> +CONFIG_HW_RANDOM_VIRTIO=y

-- 

Sasha.

