Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2FJOP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:15:27 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:49310 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2FJOP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:15:26 -0400
Message-ID: <4FD4ABFC.1060008@free.fr>
Date: Sun, 10 Jun 2012 16:15:24 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2.19 kernel panic does not enter KDB
References: <4FD4837B.5040200@free.fr> <20120610123420.52af4e1a@pyramind.ukuu.org.uk> <4FD48744.3000602@free.fr> <CAFLxGvwtCDCdWoXCBr2nytm93Kyei-pLoioGGxhu_+TMFfdNzQ@mail.gmail.com>
In-Reply-To: <CAFLxGvwtCDCdWoXCBr2nytm93Kyei-pLoioGGxhu_+TMFfdNzQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 14:37, richard -rw- weinberger wrote:

>> So the bug is still that KDB is not entered.
>
> The problem with proprietary code is that *anything* can happen.
> If the crash happened within the Nvidia binary blob you are toasted...
>

Yes. I just want to be sure it is the case. Even if display it dead, I 
expect that keyboard may help to reboot, sync disk but unless I dot not 
hit the correct key sequence it doesn't.

--eric
