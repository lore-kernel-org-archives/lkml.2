Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1BWHBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:01:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36153 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1BWHBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:01:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gbE5eAMiLjcu/QMED5TEL6wpBPDQhpohzUP92mMvsGqaPR+9IJRRV5a1nZo8XaQtIR
         uOFR/Y9klZFZg75N5+R6mrZCJxDi5h0xcA/Mq+AkSGxKURHd2t4fV/K8PPTIH0ZoIvzb
         ek9trkjSDMJ4ZihkuyOZ0/6nMncYDB69WUmX8=
MIME-Version: 1.0
In-Reply-To: <20110222134735.0bfbec8b.randy.dunlap@oracle.com>
References: <20110222183437.ec2807bf.sfr@canb.auug.org.au>
	<20110222134735.0bfbec8b.randy.dunlap@oracle.com>
Date: Wed, 23 Feb 2011 08:01:12 +0100
Message-ID: <AANLkTinb4f5QLRQ8kfiSkjdx9YzZpdYk-=YD9Qmejz+g@mail.gmail.com>
Subject: Re: [PATCH -next] eeepc-wmi: kconfig changes to fix build errors
From: Corentin Chary <corentin.chary@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Garrett <mjg@redhat.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 10:47 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix eeepc-wmi build when CONFIG_HOTPLUG_PCI is not enabled:
>
> eeepc-wmi.c:(.text+0x3bc5e9): undefined reference to `pci_hp_deregister'
> eeepc-wmi.c:(.text+0x3bcca4): undefined reference to `__pci_hp_register'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/platform/x86/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20110222.orig/drivers/platform/x86/Kconfig
> +++ linux-next-20110222/drivers/platform/x86/Kconfig
> @@ -447,6 +447,7 @@ config EEEPC_WMI
>        depends on EXPERIMENTAL
>        depends on BACKLIGHT_CLASS_DEVICE
>        depends on RFKILL || RFKILL = n
> +       depends on HOTPLUG_PCI
>        select INPUT_SPARSEKMAP
>        select LEDS_CLASS
>        select NEW_LEDS
>

Sorry for that...

Acked-by: Corentin Chary <corentin.chary@gmail.com>


-- 
Corentin Chary
http://xf.iksaif.net
