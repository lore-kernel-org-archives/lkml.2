Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0JPQKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:10:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56917 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0JPQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FDJBhjcTg2EA3uyr5zskARXGYtMFhBL4fKFmB4QcSSdQtHkC/0xqmWYb6Hov+Wa7Lu
         S8ZnMDDiNYDPHq5i7HGo42LecQ+vfdBmE+T7iie6CtA+w+iAwnJOFQNNr9N4k9Adm//B
         C5qSX8T/vLUlpSSsnXUPU5sI0Vgl2QeFGikok=
MIME-Version: 1.0
In-Reply-To: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
References: <1287077397-21781-1-git-send-email-gadiyar@ti.com>
Date: Sat, 16 Oct 2010 18:10:13 +0200
X-Google-Sender-Auth: g3FOpngzrvD_pL7RQIisW8ofPAE
Message-ID: <AANLkTin3Z+x0pxrDg4vAa5Wuahc3uGC=ve7=3mHE6KBC@mail.gmail.com>
Subject: Re: [PATCH RFC] arm: genirq: fix boot on arm platforms
From: Linus Walleij <linus.walleij@stericsson.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/14 Anand Gadiyar <gadiyar@ti.com>:

> We seem to be using desc->status without assigning desc to
> anything. Fix this by adding back the code that was originally
> there.
>
> I'm not 100% sure this is the correct fix. I'm just reporting
> that this small change allows me to boot again.

Thank you for this patch Anand, it makes my
ARM RealView PB1176 and my ST-Ericsson U8500 prototype
both boot again on the -next tree!

Tested-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
