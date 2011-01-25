Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1AYMLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:11:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35526 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1AYMLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:11:03 -0500
Message-ID: <4D3EBD8F.2060608@mvista.com>
Date: Tue, 25 Jan 2011 15:09:51 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Anoop P.A" <anoop.pa@gmail.com>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Cpu features overrides for msp platforms.
References: <1295943797-20467-1-git-send-email-anoop.pa@gmail.com>
In-Reply-To: <1295943797-20467-1-git-send-email-anoop.pa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-01-2011 11:23, Anoop P.A wrote:

> From: Anoop P A<anoop.pa@gmail.com>


> Signed-off-by: Anoop P A<anoop.pa@gmail.com>
[...]

> diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h b/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
> new file mode 100644
> index 0000000..a80801b
> --- /dev/null
> +++ b/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
> @@ -0,0 +1,21 @@
> +/*
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2003, 04, 07 Ralf Baechle (ralf@linux-mips.org)

    If you're the author, how come it's Ralf's copyright here?

WBR, Sergei
