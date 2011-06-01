Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1FAFiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 01:38:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65289 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1FAFh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 01:37:59 -0400
Message-ID: <4DE5D032.3050007@monstr.eu>
Date: Wed, 01 Jun 2011 07:37:54 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH v3 08/13] microblaze: select HAVE_SECCOMP_FILTER and provide
 seccomp_execve
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com> <1306897845-9393-8-git-send-email-wad@chromium.org>
In-Reply-To: <1306897845-9393-8-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Drewry wrote:
> Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
> system call numbering for execve and selecting HAVE_SECCOMP_FILTER.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  arch/microblaze/Kconfig               |    1 +
>  arch/microblaze/include/asm/seccomp.h |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)

Acked-by: Michal Simek <monstr@monstr.eu>

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
