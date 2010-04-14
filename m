Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0DNRjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:39:45 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:39031 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab0DNRjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=an82oqCX2JTzM1pzrv1/DJd/bJsL2psOn6iNf56YRMNzsJmMVExD0uMhZ1bwTN/tlM
         ies9dpw9KLBBClrdOypm/C9jlpuSPRlDdHr34wq4T0jz6GGegrroGlvBLLQq76bMdytQ
         n3LuEuXBAeBslc5iTOOL7rcVyfEx4tuL9pI8Q=
MIME-Version: 1.0
In-Reply-To: <1269450986-3714-1-git-send-email-manuel.lauss@gmail.com>
References: <1269450986-3714-1-git-send-email-manuel.lauss@gmail.com>
Date: Wed, 14 Apr 2010 19:39:41 +0200
Message-ID: <t2wf861ec6f1004141039kf25acdddrb1e4639c17ecc8f6@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] serial 8250 platform PM hooks
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?  Noone interested?

On Wed, Mar 24, 2010 at 7:16 PM, Manuel Lauss
<manuel.lauss@googlemail.com> wrote:
> The following 2 patches implement a PM hook for platform 8250
> UARTs and a sample PM implementation for a MIPS SoC.
>
> Patch #1 hooks a new .pm callback in struct plat_serial8250_port to
> the rest of serial_core's PM infrastructure,
>
> Patch #2 implements uart power gating for Alchemy line of mips socs
> using the new hook.
>
> With these 2 patches serial console on my test system survives
> suspend/resume cycles without having to resort to platform-specific
> hacks in the PM code.
>
> Thanks,
>     Manuel Lauss
>
> Manuel Lauss (2):
>  8250: allow platform uarts to install PM callback.
>  Alchemy: UART PM through serial framework.
>
>  arch/mips/alchemy/common/platform.c |   17 +++++++++++++++++
>  arch/mips/alchemy/common/power.c    |   32 --------------------------------
>  drivers/serial/8250.c               |   31 ++++++++++++++++++++++++++++---
>  include/linux/serial_8250.h         |    6 ++++++
>  4 files changed, 51 insertions(+), 35 deletions(-)
>
>
