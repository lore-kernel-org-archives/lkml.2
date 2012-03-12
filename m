Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2CLMCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:02:12 -0400
Received: from mail.aixtema.de ([212.117.64.100]:33193 "EHLO mail.aixtema.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab2CLMCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:02:10 -0400
Message-ID: <1331553720.6203.5.camel@mobile>
Subject: Re: Patch for Sitecom LN-031
From: Joerg Neikes <j.neikes@midlandgate.de>
To: David Miller <davem@davemloft.net>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 13:02:00 +0100
In-Reply-To: <20120311.155308.854791460127462538.davem@davemloft.net>
References: <1331282643.5426.6.camel@mobile>
	 <20120311.155308.854791460127462538.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.1.16; AVE: 7.9.10.20; VDF: 7.11.25.22; host: mail.aixtema.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 11.03.2012, 15:53 -0700 schrieb David Miller:
> From: Joerg Neikes <j.neikes@midlandgate.de>
> Date: Fri, 09 Mar 2012 09:44:03 +0100
> 
> > This patch adds support for the Sitecom LN-031 USB adapter with a AX88178 chip.
> > 
> > Added USB id to find correct driver for AX88178 1000 Ethernet adapter.
> > 
> > Signed-off-by: Joerg Neikes <j.neikes@midlandgate.de>
> 
> Applied, but please put more appropriate content in your subject
> lines in the future.
> 
> You should, at a minimum, prefix the subject line with the driver or
> subsystem name you are modifying.  In this case something like
> "asix: " would have been appropriate.
> 

Thanks for the information about the subsystem.
Next time i will write it to the subject line.

This was my first change ever send for Kernel adding.


