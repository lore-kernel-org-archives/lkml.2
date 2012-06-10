Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2FJLir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:38:47 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:51052 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2FJLiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:38:46 -0400
Message-ID: <4FD48744.3000602@free.fr>
Date: Sun, 10 Jun 2012 13:38:44 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2.19 kernel panic does not enter KDB
References: <4FD4837B.5040200@free.fr> <20120610123420.52af4e1a@pyramind.ukuu.org.uk>
In-Reply-To: <20120610123420.52af4e1a@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 13:34, Alan Cox wrote:

>
> I think you are on the wrong list. Nvidia have kernel source code, we
> don't have code to their proprietary stuff. Only they can help you.
>
> It's quite possible the box is hanging so hard that kdb can't help you.
> In that case you'll again need someone with their proprietary Nvidia
> source to help you.

Maybe you are still annoyed by the picture linus has posted but that 
type of answer helps nothing. I know nobody there is going to debug 
nvidia driver but I'm not even sure its not something else. Neither are you.

So the bug is still that KDB is not entered.

--eric

