Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1HQUjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62052 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1HQUjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 01/36] Hexagon: Add generic headers
Date: Wed, 17 Aug 2011 21:19:07 +0200
Message-ID: <1652013.0Mm3aOmd9K@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163519.957524170@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163519.957524170@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Lb+MomFRNngNEYnHxQKoDAW4r+RGOvbazpJlm8r1/zc
 fHqt+OsLt+mL0dmPxepFTwKoqIFqE3W19nf8kdjd2zT1IpYnm5
 Shn5Z/uzd4PWGOv3MLLosvqHG1E7BO3J3eCNCOodAij4PSc0O5
 LTjg9t9pUp55n4QR9y+O13oVZBsSqb5TdUyydMKzgBbZT4yvKy
 04ecjchZDq5f7R938JCnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:34:58 Richard Kuo wrote:
>  arch/hexagon/include/asm/bug.h               |    1 
>  arch/hexagon/include/asm/cpumask.h           |    1 
>  arch/hexagon/include/asm/cputime.h           |    1 
>  arch/hexagon/include/asm/device.h            |    1 
>  arch/hexagon/include/asm/div64.h             |    1 
>  arch/hexagon/include/asm/emergency-restart.h |    1 
>  arch/hexagon/include/asm/errno.h             |    1 
>  arch/hexagon/include/asm/fb.h                |    1 
>  arch/hexagon/include/asm/fcntl.h             |    1 
>  arch/hexagon/include/asm/ioctl.h             |    1 
>  arch/hexagon/include/asm/ioctls.h            |    1 
>  arch/hexagon/include/asm/ipc.h               |    1 
>  arch/hexagon/include/asm/ipcbuf.h            |    1 
>  arch/hexagon/include/asm/irq_regs.h          |    1 
>  arch/hexagon/include/asm/kdebug.h            |    1 
>  arch/hexagon/include/asm/kmap_types.h        |    1 
>  arch/hexagon/include/asm/local.h             |    1 
>  arch/hexagon/include/asm/local64.h           |    1 
>  arch/hexagon/include/asm/mman.h              |    1 

There is no need for these one-line files any more, see
arch/openrisc/include/asm/Kbuild

	Arnd
