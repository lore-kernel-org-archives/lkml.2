Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1LUUfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:35:16 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51065 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134Ab1LUUfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:35:12 -0500
Date: Wed, 21 Dec 2011 22:35:05 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        mingo@elte.hu
Subject: Re: [PATCH] kvm tool: Implement a serial FIFO emulation
In-Reply-To: <alpine.LFD.2.02.1112211632490.3020@ionos>
Message-ID: <alpine.LFD.2.02.1112212233310.2642@tux.localdomain>
References: <alpine.LFD.2.02.1112211632490.3020@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Thomas Gleixner wrote:
> Adding FIFO functionality to the serial emulator to speed up the
> console handling.
>
> This also restricts sysrq functionality to the first serial port and
> fixes the sysrq injection, which was broken because nothing ever reset
> the BI status bit in the LSR.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied, thanks! Ingo, this speeds up serial console significantly and 
hopefully fixes things up for you as well.

 			Pekka
