Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0CaO0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:26:52 -0400
Received: from mail-iw0-f199.google.com ([209.85.223.199]:44559 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0CaO0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <20100331064707.GA11428@isilmar.linta.de>
References: <1269972879-27400-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> 
	<20100331064707.GA11428@isilmar.linta.de>
From: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Wed, 31 Mar 2010 11:26:28 -0300
Message-ID: <w2ycecb6d8f1003310726lead65adcq2de9cb4b8560a034@mail.gmail.com>
Subject: Re: [PATCH] ARM: pcmcia: Adds nanoEngine PCMCIA support.
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       Russell King <linux@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>, Eric Miao <eric.y.miao@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Dmitry Artamonow <mad_soft@inbox.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominik,

On Wed, Mar 31, 2010 at 03:47, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> On Tue, Mar 30, 2010 at 03:14:39PM -0300, Marcelo Roberto Jimenez wrote:
>> This patch adds nanoEngine PCMCIA support, with support for two sockets.
>>
>> In order to have a fully functional pcmcia subsystem in a BSE nanoEngine board
>> you should carefully read this:
>>
>> http://cambuca.ldhs.cetuc.puc-rio.br/nanoengine/
>
> That website still talks about pcmcia-cs ... which was superseded by
> pcmciautils.

Indeed, pcmcia-cs is not needed anymore, in fact, does not work with
my setup, I am using pcmciautils now. The web site has not been
updated because it refers to the project as it was with the kernel 2.4
implementation. The link is there because there are two serious
hardware problems when implementing PCMCIA with nanoengine: one is
that it needs external logic, the other is that it is necessary to
reprogram the bogus version of the CPLD that originally came with the
nanoEngine board.

> The patch gets an
>
>        Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
>
> as I assume that Russell prefers to take it into his tree?

Thanks!

> Best,
>        Dominik

Regards,
Marcelo.
