Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0KPPaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:30:23 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:55526 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0KPPaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:30:22 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Documentation about RS485 serial communications
Date: Tue, 16 Nov 2010 16:28:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-gentoo-r12; KDE/4.4.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Claudio Scordino <claudio@evidence.eu.com>,
        Grant Edwards <grant.b.edwards@gmail.com>, Greg KH <gregkh@suse.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk> <4CDBC3EC.6020707@evidence.eu.com> <20101116143016.GB6527@ucw.cz>
In-Reply-To: <20101116143016.GB6527@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161630.19107.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday 16 November 2010, 15:30:16 Pavel Machek wrote:
> > Documentation about RS485 serial communications
> 
> I have seen hardware (kontron pmc-6l) that was capable of switching
> between RS232, RS485 and one other standard by software.

Maybe you mean RS422 here.

> Is such hw common? If so, should we have standard interface?

Especially in industrial system, you may have RS485 or RS422 additionally to 
RS232. This also often means switching some GPIO to change the external signal 
levels. Any the drivers must also be capable of turning on and off the 
transmitter.

Best regards,
Alexander
