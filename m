Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1AYMQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:16:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54594 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1AYMPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kZNY5/HtJBHDfw+gBgu4U9ASNQ6POF/0vQI0lwGzS6HCHYkppF0ivfyy7Ik+DP558B
         Qm6JgCVQs5j0pRTtgdxTxXRQlDBSxQffeBemBt/ccjAcVVi9guho8xWbU7IMJoAsdY9B
         xaFsgsd446KipXVFH+qzp1n9/6IDJCfo8hHBA=
Subject: Re: [PATCH 6/6] Cpu features overrides for msp platforms.
From: Anoop P A <anoop.pa@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D3EBD8F.2060608@mvista.com>
References: <1295943797-20467-1-git-send-email-anoop.pa@gmail.com>
	 <4D3EBD8F.2060608@mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 18:02:03 +0530
Message-ID: <1295958724.27661.545.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 15:09 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 25-01-2011 11:23, Anoop P.A wrote:
> 
> > From: Anoop P A<anoop.pa@gmail.com>
> 
> 
> > Signed-off-by: Anoop P A<anoop.pa@gmail.com>
> [...]
> 
> > diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h b/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
> > new file mode 100644
> > index 0000000..a80801b
> > --- /dev/null
> > +++ b/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
> > @@ -0,0 +1,21 @@
> > +/*
> > + * This file is subject to the terms and conditions of the GNU General Public
> > + * License.  See the file "COPYING" in the main directory of this archive
> > + * for more details.
> > + *
> > + * Copyright (C) 2003, 04, 07 Ralf Baechle (ralf@linux-mips.org)
> 
>     If you're the author, how come it's Ralf's copyright here?

I just copied that file from some other platform. 

> 
> WBR, Sergei


