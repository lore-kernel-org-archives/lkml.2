Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0FGAI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 20:08:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44988 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab0FGAIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 20:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RnqCYwd+zDb4seSMmigjzIhkDumrMPY/rR8Ldt5U6WE0DUtdQRMQ1LG2V0MtLKsSFd
         9HjxiwO4t1SXOwZ2D9h07ZEz0rK8RsAYPJ++rW3jZm+D+NHeCGZBFvphGLf76DbS8/kI
         xwIaEBAsXraelmXBFNwHZAMdIe7soRqU7mxDY=
MIME-Version: 1.0
In-Reply-To: <4C0C22C4.3010705@orcon.net.nz>
References: <4C0C22C4.3010705@orcon.net.nz>
Date: Sun, 6 Jun 2010 20:08:51 -0400
Message-ID: <AANLkTim9aWVzb7v5fnS6x3ghMU2_tpaLlbZu3SKXV_0R@mail.gmail.com>
Subject: Re: 2.6.35-rc2 compilation error on Alpha
From: Matt Turner <mattst88@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 6:35 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> When compiling 2.6.35-rc2 for Alpha architecture the following compiler
> error is seen:
>
>  CC      arch/alpha/kernel/asm-offsets.s
> In file included from include/linux/kernel.h:17,
>                 from include/linux/sched.h:54,
>                 from arch/alpha/kernel/asm-offsets.c:9:
> include/linux/bitops.h: In function ‘hweight_long’:
> include/linux/bitops.h:49: error: implicit declaration of function
> ‘__arch_hweight32’
>
> Cheers
> Michael.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-alpha" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Yeah, it was a stupid typo in
1527bc8b928dd1399c3d3467dd47d9ede210978a. I've fixed it and put the
patch in my tree for Linus.

Unfortunately, there's another compile error--PCI breakage. I'll do this too...

Thanks,
Matt
