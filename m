Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1AKQCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:02:45 -0500
Received: from relais.videotron.ca ([24.201.245.36]:65494 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1AKQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:02:43 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 11 Jan 2011 11:02:42 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alexander Holler <holler@ahsoftware.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: ARM: relocation out of range (when loading a module)
In-reply-to: <4D2C7484.3050309@ahsoftware.de>
Message-id: <alpine.LFD.2.00.1101111101390.16547@xanadu.home>
References: <4D2B4CE4.9080309@ahsoftware.de>
 <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
 <4D2BFA08.5030104@ahsoftware.de> <4D2C7484.3050309@ahsoftware.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Alexander Holler wrote:

> Thinking a bit more about that (for me unexcpected) "relocation out of range"
> error when loading a module, I'm curious if there could be other conditions
> which would lead to that error. Especially conditions which could be generated
> by the userspace or remote from some network.

No.


Nicolas
