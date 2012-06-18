Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2FRMSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:18:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49533 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2FRMSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZzj2J8UY30Ee+XEtf2NarJJzVzzHCWkucptUuQb3L_ww@mail.gmail.com>
References: <1339946252-21019-1-git-send-email-otavio@ossystems.com.br>
	<1339946252-21019-2-git-send-email-otavio@ossystems.com.br>
	<CACRpkdZzj2J8UY30Ee+XEtf2NarJJzVzzHCWkucptUuQb3L_ww@mail.gmail.com>
Date: Mon, 18 Jun 2012 09:18:42 -0300
X-Google-Sender-Auth: EaXG7RJ8oGWVUibxrCe-VHP50Aw
Message-ID: <CAP9ODKo+wqeyVRX3dLXdktYD2yps1d6E1UZs3zyikAZi_pf7jg@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-mxs: fix implicit declaration of free()
From: Otavio Salvador <otavio@ossystems.com.br>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Devendra aaru <devendra.aaru@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 3:04 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> But:
>
>>  free_group:
>> -       if (!purecfg)
>> -               free(group);
>> +       kfree(group);
>
> Why did you delete the if (!purecfg) clause?

Ouch! I missread it as if where checking for valid group.

Thanks by noticing it.

I will drop it from my tree then.

-- 
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
