Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0JVJgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:36:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0JVJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:36:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: sedat.dilek@gmail.com
Subject: Re: linux-next: next-20101022 broken with unset CONFIG_BKL
Date: Fri, 22 Oct 2010 11:36:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
        Jan Harkes <jaharkes@cs.cmu.edu>
References: <AANLkTi=vUA-u20egbpH1Wu4ek-craz7aZUxWmobL8OhD@mail.gmail.com> <201010221124.32842.arnd@arndb.de> <AANLkTimn9u-m8eOA7dQH6kCNriebEnnbYZaP_=rnp1pv@mail.gmail.com>
In-Reply-To: <AANLkTimn9u-m8eOA7dQH6kCNriebEnnbYZaP_=rnp1pv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221136.12073.arnd@arndb.de>
X-Provags-ID: V02:K0:gA0AgJbQo3GkrPU7r+DMPUfS/b9jC9P6V77MXH79gX5
 5EZ5ZkL9DXoO81M+TsNCJxWA4pkZBeu2zy+otImr6LOf2CFRd1
 Toe7nElqJKA9knqLD9SMyuacb03S8/gGuajLO7T6mj+csK2A+a
 5J/3m2UHieaNf8Id66tWeYW2pg4+69ql2nhZ9wFny3r8OmYt+N
 uisVVza2MliiVeTRqAUIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 11:30:17 Sedat Dilek wrote:

> Wow, you answer in realtime :-), Arnd.
> Thanks for the explanations and I agree with you to wait for 27-rc1
> and then to remove BKL.
> Me just doing early-testing...
> 
> A pointer to the patch?
> Thanks in advance.

The thread is "Coda: remove BKL", You can find it on patchwork.

	Arnd
