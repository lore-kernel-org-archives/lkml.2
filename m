Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab0JTIAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:00:20 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:52332 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0JTIAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:00:18 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Documentation about RS485 serial communications
Date: Wed, 20 Oct 2010 10:00:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-gentoo-r11; KDE/4.4.5; x86_64; ; )
Cc: Grant Edwards <grant.b.edwards@gmail.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk> <201010191727.53314.alexander.stein@systec-electronic.com> <i9kk4o$svc$1@dough.gmane.org>
In-Reply-To: <i9kk4o$svc$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010201000.14905.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010, 19:22:32 Grant Edwards wrote:
> Yes, the AT91 UARTs do have a built-in half-duplex mode that will
> automatically control line direction by toggling RTS.
> 
> That can used to control external half-duplex hardware like an RS485
> transceiver or any RS232-connected half-duplex device like some
> modems.
> 
> Though the Atmel docs refer to it as "RS485 mode" there is no RS485
> transceiver in the AT91 parts (AFAIK), and "RS485 mode" isn't specific
> to RS485 - it can be used with any external half-duplex hardware.

Out of curiosity, how can I add RS485 (or whatever) support for other serial 
devices like e.g. i.mx serial? Is there some driver independent interface 
which only gets filled in board configs like setting some GPIO pins?

Alexander
