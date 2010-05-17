Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab0EQOBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:01:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:50740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0EQOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:01:43 -0400
Date: Mon, 17 May 2010 07:04:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Donald Allen <donaldcallen@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: tickless scheduling
Message-ID: <20100517070440.13d193aa@infradead.org>
In-Reply-To: <AANLkTinFlyz2d4Y6Viw0aWfe6mb6F7Ev4UCvkkQVFADd@mail.gmail.com>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	<AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	<AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	<1273540344.3843.101.camel@localhost.localdomain>
	<AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	<AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	<1273697523.2856.3.camel@localhost.localdomain>
	<AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
	<alpine.LFD.2.00.1005170123090.3368@localhost.localdomain>
	<AANLkTinFlyz2d4Y6Viw0aWfe6mb6F7Ev4UCvkkQVFADd@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 09:44:47 -0400
Donald Allen <donaldcallen@gmail.com> wrote:

> I will do the experiment suggested by Arjan van de Ven and report the
> results of that separately.


since you're losing interrupts.. another good option to try is "irqpoll"


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
