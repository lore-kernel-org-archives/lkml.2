Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1LJPRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 10:17:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52849 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452Ab1LJPRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 10:17:21 -0500
Date: Sat, 10 Dec 2011 17:17:12 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        mingo@elte.hu
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
In-Reply-To: <20111210132220.083204833@linutronix.de>
Message-ID: <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
References: <20111210132220.083204833@linutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Dec 2011, Thomas Gleixner wrote:
> We observed massive hangs of the serial console in kvm tool which
> turned out to be caused by the bogus emulation of the interrupt line
> behaviour.
>
> This series cleans up and simplifies the serial code and in the last
> step fixes the interrupt handling proper.

Applied, thanks Thomas!
