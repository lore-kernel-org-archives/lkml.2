Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0KHOCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:02:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58516 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0KHOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OOKrkurLNBiyCNnYS/Ukpvu2SEuNUbuHjEYTxN/93aG9RUIC22I5NKpFlw0qjrKVdh
         Lr2SbCjfdjG+Tdgmrs+IkWdq8br2wcngOhIGfzRapT1SiIZ5xucZKa/TmS0vbOh9Q6dV
         Pi7QgLJza03JFq9mUNadcFzV1xlmBvaT6yjsM=
Message-ID: <4CD802B4.1040704@gmail.com>
Date: Mon, 08 Nov 2010 15:01:24 +0100
From: Thomas Weber <thomas.weber.linux@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101104 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
References: <4CAD818B.2070603@iis.fraunhofer.de>
In-Reply-To: <4CAD818B.2070603@iis.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.10.2010 10:15, schrieb Manuel Stahl:
> This patch adds support for the sc16is7x2 SPI to UART chips.
> Each chip has two UARTs and 8 GPIOs.

Hello Manuel,

can you send the patch inline?

Why you check in your probe function the gpio_base but not the uart_base?


Thomas



