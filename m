Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1JCJgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:36:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1JCJgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:36:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tty/serial: atmel_serial: __devinit_p for probe function
Date: Mon, 03 Oct 2011 11:36:01 +0200
Message-ID: <4355360.0xR5ZY7sEk@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <d7c2023edfbeb3d21bccd5b997f7806874b01b04.1317636473.git.nicolas.ferre@atmel.com>
References: <cd489c1d28c26624d6b68399d222aec371045e53.1317634987.git.nicolas.ferre@atmel.com> <d7c2023edfbeb3d21bccd5b997f7806874b01b04.1317636473.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:O3QNVuLn4ukKan61dgJ8VjNyBE/OsyPXbG2ZhFjmXSY
 j4tC6OdZZliv4tzmdXe7EXMPCX3Lj+TaXZ4Mtm0VPLqq43NHMk
 nu9tjnFmPVUeIGeH0gpr4JnetozmzlUT8x5ElReiKNZOsmmGmQ
 KpKUHXksNgSQS0u2XIxgOkTleUgdgmcSRpj7HhAGlQWOBNZNkZ
 XbzhTsiGgJgrc+ep3XX1dWOvMTBNR7wNBqlqaW/GrexZFfj4dE
 hqrWnsHTp+U4BBumOz77TjtmRB0i9mUCu5CzYxcH9FqsblYWOc
 aTN7UUNbRC6oqmQlznBSmEoEjOcG/vchtNEou11ap58+51ePt/
 mYQPb7xjXc0dDOrb4Ej4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 12:11:19 Nicolas Ferre wrote:
>  }
>  
>  static struct platform_driver atmel_serial_driver = {
> -       .probe          = atmel_serial_probe,
> +       .probe          = __devinit_p(atmel_serial_probe),
>         .remove         = __devexit_p(atmel_serial_remove),
>         .suspend        = atmel_serial_suspend,
>         .resume         = atmel_serial_resume,

Still wrong: __devinit_p does not exist and is not needed.

What bug are you trying to fix here?

	Arnd
