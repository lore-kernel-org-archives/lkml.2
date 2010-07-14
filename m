Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0GNNgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:36:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0GNNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WyIV2ioPKYQb4CE6+XNtfK+/Vgb9CxAsQ7dd+qctI2MUglZdM6UBfMMIeP/XgCITjx
         e3ZZKMKEa7Fw7Sqrlc2+ShZXs3N6kllaA3TOUoCD+DSIeAr8FFEF5CdgDUYsBD8Dqn3X
         Xtep4Yg1y48jVE/IZCTABK1n8LntW1XAzvUQ4=
MIME-Version: 1.0
In-Reply-To: <9df7166bb950e7fbc12d1be9f2b9f9cbb9961187.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<9df7166bb950e7fbc12d1be9f2b9f9cbb9961187.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 14 Jul 2010 09:35:39 -0400
Message-ID: <AANLkTimsHAAvMI8euhr11n5JXX5iQTMG9hMx08Nfpemp@mail.gmail.com>
Subject: Re: [PATCH 3/3] usb/host || arch/arm: Remove dead CONFIG_ARCH_KARO
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@karo-electronics.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o6EDaRKs008312

On Wed, Jul 14, 2010 at 07:32, Christian Dietrich wrote:
> CONFIG_ARCH_KARO doesn't exist in Kconfig and is never defined anywhere
> else, therefore removing all references for it from the source code.
>
> --- a/arch/arm/tools/mach-types
> +++ b/arch/arm/tools/mach-types
> @@ -204,7 +204,6 @@ omaha                       ARCH_OMAHA              OMAHA                   186
>  ta7                    ARCH_TA7                TA7                     187
>  nova                   SA1100_NOVA             NOVA                    188
>  hmk                    ARCH_HMK                HMK                     189
> -karo                   ARCH_KARO               KARO                    190
>  fester                 SA1100_FESTER           FESTER                  191
>  gpi                    ARCH_GPI                GPI                     192
>  smdk2410               ARCH_SMDK2410           SMDK2410                193

i dont think you should be modifying the arm registry.  there are
probably a lot of boards listed here that you wont find referenced in
the tree, but this is by design.
-mike
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
