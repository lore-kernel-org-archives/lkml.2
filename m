Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1FTUJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:09:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1FTUJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:09:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Mon, 20 Jun 2011 22:07:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, Alan Stern <stern@rowland.harvard.edu>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1106201306210.2142@xanadu.home> <4DFF85D6.1090104@ahsoftware.de>
In-Reply-To: <4DFF85D6.1090104@ahsoftware.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202207.23104.arnd@arndb.de>
X-Provags-ID: V02:K0:3vyqaeYD4Q5CEesstgLuTXC/F8au91GtysO0lMBWKho
 4cGJVbimVmipqKMIaFPcRsNUe56blwBvV9c4M6kgQ2Rja98Hrn
 TSS9J5Z/OhVIr9OwOQ7DfSESgZteQXUxi8QscnjkjUGo8aD8Cz
 UO80F2TeHUlYgb0U5Ve9B4X2I6J5oesJupXsg0rcD+NpiQrGp7
 aQGJANsz7bM07phTa1KLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011 19:39:34 Alexander Holler wrote:
> That packed without an additional aligned() caused errors on ARM with 
> gcc 4.6 is another problem which got (currently) fixed by removing packed.

Packed caused errors because it is *wrong*. The code as it was used undefined
behavior in the language.

> But this introduces imho doubts and uncertainty about if padding bytes 
> could be between the members, therefore I would prefer to use packed 
> with aligned instead of removing the packed.

Packing was never an issue here, please stop talking about it.

	Arnd
