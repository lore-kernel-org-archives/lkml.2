Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab2IGTod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:44:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab2IGTo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:44:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 18/31] arm64: VDSO support
Date: Fri, 7 Sep 2012 19:44:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-19-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-19-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071944.23703.arnd@arndb.de>
X-Provags-ID: V02:K0:Q7AZ3lZ9yydlcFqJUi4Rdi0UoT/n0ev/gyvG53YRaSV
 xZWnA1+1dgygoJRu1jeV5imsW47BmdSErsTpFuB+eKP9FDCCLC
 En/M0q25xo+cFZRqg7Vu0S34ze97HWuaWbd4VMKhhT0isU0CCP
 KKXJN7uy1EMNcrMiPWYS4SviUSNLV4sjHJzZuA72xnEzb96QeQ
 0A33fs0+CJWcjc4tGa2S+KFHFYwSaMF40uLUoWVRPkPHiqVcU7
 yXMCC3CyAxI966jo29dhKZcVHMSUmwgzc3+A3vGfyznGm74XR4
 65rb6UBFvOz7Yw+fi15BgfSkTdEhXg+LYiVOGQLCylct3F4rvP
 CfTJmIwNJ7gDiTsigeYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> This patch adds VDSO support for 64-bit applications. The VDSO code is
> currently used for sys_rt_sigreturn() and optimised gettimeofday()
> (using the user-accessible generic counter).
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
