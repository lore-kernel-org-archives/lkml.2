Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0LaKxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:53:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:55085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0LaKxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:53:24 -0500
Message-ID: <4D1DB61C.2050508@infradead.org>
Date: Fri, 31 Dec 2010 08:53:16 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, aospan@netup.ru
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
References: <201012310726.31851.liplianin@netup.ru>
In-Reply-To: <201012310726.31851.liplianin@netup.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-12-2010 03:26, Igor M. Liplianin escreveu:
> It uses STAPL files and programs Altera FPGA through JTAG.
> Interface to JTAG must be provided from main device module,
> for example through cx23885 GPIO.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>

There's something wrong with the way you sent your patches: They
were sent with some random dates (most patches are from Aug), so 
they went out-of-order in patchwork and at the default email display
order. 

Also, patch 4/18 seems missed.

Cheers,
Mauro
