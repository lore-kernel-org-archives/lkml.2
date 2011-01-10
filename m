Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1AJW0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:26:13 -0500
Received: from relais.videotron.ca ([24.201.245.36]:16019 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab1AJW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:26:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 10 Jan 2011 17:26:09 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
        linux@arm.linux.org.uk
Subject: Re: ARM: relocation out of range (when loading a module)
In-reply-to: <4D2B4CE4.9080309@ahsoftware.de>
Message-id: <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
References: <4D2B4CE4.9080309@ahsoftware.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Alexander Holler wrote:

> Hello,
> 
> I've build a kernel 2.6.37 for an armv5-device which includes an initramfs of
> about 16MB (uncompressed, result is a kernel of about 6MB) and I now getting
> errors when trying to load a module (which is included in that initramfs):

Do you really need to have such a bit initramfs?

What you can do to work around this issue is to load your initramfs 
separately as a initrd ramdisk image. , and not combine it with the 
kernel image.


Nicolas
