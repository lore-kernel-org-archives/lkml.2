Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab2FUMMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:12:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:48913 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab2FUMMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:12:46 -0400
Message-ID: <1340280757.18025.6.camel@twins>
Subject: Re: [PATCH -v2 2/2] x86, microcode: Make reload interface per system
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date: Thu, 21 Jun 2012 14:12:37 +0200
In-Reply-To: <1340280437-7718-3-git-send-email-bp@amd64.org>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
	 <1340280437-7718-3-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 14:07 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> The reload interface should be per-system so that a full system ucode
> reload happens (on each core) when doing
> 
> echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> Move it to the cpu subsys directory instead of it being per-cpu.
> 
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Peter Zijlstra <peterz@infradead.org> 
