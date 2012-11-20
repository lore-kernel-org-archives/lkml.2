Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2KTMlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:41:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34076 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTMln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:41:43 -0500
MIME-Version: 1.0
In-Reply-To: <8aa73cfc61db3e516713e31a79ed38b03cf77e96.1353349191.git.josh.cartwright@ni.com>
References: <cover.1353349191.git.josh.cartwright@ni.com>
	<8aa73cfc61db3e516713e31a79ed38b03cf77e96.1353349191.git.josh.cartwright@ni.com>
Date: Tue, 20 Nov 2012 13:41:42 +0100
X-Google-Sender-Auth: PH5AqHY7Xe6wdglzulbd4d8j4nc
Message-ID: <CAHTX3dJEER5T1eXbkQNF_z627Ooco1aLeNUTKYv69AD6xAiCrg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: zynq: make use of debug_ll_io_init()
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/19 Josh Cartwright <josh.cartwright@ni.com>:
> Convert low-level debugging routines to make use of debug_ll_io_init().
> This is part of the preparation for ARCH_MULTIPLATFORM support for Zynq.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/Kconfig.debug                             |  1 +
>  .../mach/debug-macro.S => include/debug/zynq.S}    |  3 +--
>  arch/arm/mach-zynq/common.c                        | 25 ++++++----------------
>  3 files changed, 9 insertions(+), 20 deletions(-)
>  rename arch/arm/{mach-zynq/include/mach/debug-macro.S => include/debug/zynq.S} (94%)

Tested-by: Michal Simek <michal.simek@xilinx.com>

Applied to xilinx arm-next branch.

Thanks,
Michal
