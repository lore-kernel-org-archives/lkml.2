Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0LJMfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:35:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab0LJMff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:35:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv1 000/211] unicore32 architecture support
Date: Fri, 10 Dec 2010 13:35:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>, "'Tejun Heo'" <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn> <026901cb9848$17e71ac0$47b55040$@mprc.pku.edu.cn> <alpine.LFD.2.00.1012101156230.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012101156230.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012101335.24983.arnd@arndb.de>
X-Provags-ID: V02:K0:VcUtWW02nrPPOX+w1RVyMXvNw2E1q/vjqhzfxvKeNfP
 1IsHpGBtC+5auK9NG7NTfGfXsYHuq8NoYeUds1rWgZH49kcBH/
 pkoU7X5vnEq8/6ilxpqJJXq+DOwwJw+/6KhqQ9SfqUFxXfQxKW
 06LLROBpQLYlgCAKrWlA8VPrJAiXV3r51YyVDmzg8Xzdh6PQY3
 o8278OH32Y1MeQtLIXs4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 December 2010, Thomas Gleixner wrote:
> And please mail them to yourself before you post them and make sure
> they apply and resemble exaclty what you wanted to send. I just
> noticed, that your mailer line-wrapped the patches:
> 
> +       /*
> +        * actually the registers should be pushed and pop'd conditionally,
> but
> +        * after bl the flags are certainly clobbered
> +        */
> 

Note that this and the threading automatically get handled by
'git send-email', there is probably not much point in trying
to make the currently used email program do the right thing.

Feel free to send the patches to me in private first to make
sure that the formalities of patch submission are right, then
send them to the mailing list again for discussion.

	Arnd
