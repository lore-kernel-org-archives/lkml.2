Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1FTU2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:28:51 -0400
Received: from relais.videotron.ca ([24.201.245.36]:44234 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1FTU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:28:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 16:28:49 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Holler <holler@ahsoftware.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <201106202207.23104.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1106201622160.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
 <alpine.LFD.2.00.1106201306210.2142@xanadu.home>
 <4DFF85D6.1090104@ahsoftware.de> <201106202207.23104.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Arnd Bergmann wrote:

> On Monday 20 June 2011 19:39:34 Alexander Holler wrote:
> > That packed without an additional aligned() caused errors on ARM with 
> > gcc 4.6 is another problem which got (currently) fixed by removing packed.
> 
> Packed caused errors because it is *wrong*. The code as it was used undefined
> behavior in the language.

I wouldn't call this issue as such, but this is a Red herring.

Could you please provide a pointer to the structure definition so a 
second opinion to the usefulness of __packed there could be provided?  
If it is not matching any of the fairly limited cases where having 
__packed is relevant then we can just confirm that it should go.


Nicolas
