Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1F1Kta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:49:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab1F1Ks2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:48:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/7] serial/8250: move DWAP support to arch/mips
Date: Tue, 28 Jun 2011 12:48:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <1309211120-2803-5-git-send-email-arnd@arndb.de> <20110628110642.3517cac8@lxorguk.ukuu.org.uk>
In-Reply-To: <20110628110642.3517cac8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281248.25230.arnd@arndb.de>
X-Provags-ID: V02:K0:cceH1R4+zv+daNijFxxtdZpgPy8VPrYX4UBRLByb89f
 WUdFyCyVFEdpfMxtwu/PPlCK3rfKPqnVKznyK/w+i5U4fhcgd1
 +7SQj8PfLxSZN3FaMJZL6SQf4PoTj6+Nje3JO8wuMaRdWLZqnW
 uMT3VgACBKJ+zrp+Ro31dRDUvJ8mUNscjT5mzxxQqC5sKly8K0
 hStlTbgfwdLbQTWO4QkGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Alan Cox wrote:
> On Mon, 27 Jun 2011 23:45:17 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > Only one board uses the UPIO_DWAP iotype, and nothing uses
> > the UPIO_DWAP32 iotype. It seems much cleaner to handle the
> > DWAP quirk as a new port type, and move the serial_out
> > accessor into the platform code. If more platforms start
> > using the DWAP port, that function can be moved into a
> > common location.
> 
> Half of this patch appears to be unrelated work on HUB6
> 
> Both halves look right but did you accidentally fold two patches
> together ?

Right, Jamie also pointed this out. When I re-send, I'll use Jamie's
version of the patch and make a proper patch for HUB6.

	Arnd
