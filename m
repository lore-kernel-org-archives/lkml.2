Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab1LKIP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 03:15:59 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36939 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab1LKIP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 03:15:56 -0500
Date: Sun, 11 Dec 2011 10:15:48 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        mingo@elte.hu
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
In-Reply-To: <alpine.LFD.2.02.1112102144370.3020@ionos>
Message-ID: <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Dec 2011, Thomas Gleixner wrote:
> There is a slight problem with them. I only tested them with the
> rt-guest kernels, but non rt kernels are slightly unhappy. Sorry for
> not thinking about that.
>
> Fix below.

Applied, thanks!

Ingo, how does serial console work for you with latest master? It's likely 
that Thomas' patches fix top slowness for you.

 			Pekka
