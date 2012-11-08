Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab2KHVWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:22:39 -0500
Received: from relais.videotron.ca ([24.201.245.36]:44780 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2KHVWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:22:38 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 08 Nov 2012 16:22:30 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH v4 0/4] arch/arm: support seccomp
In-reply-to: <1352408373-25047-1-git-send-email-keescook@chromium.org>
Message-id: <alpine.LFD.2.02.1211081618320.21033@xanadu.home>
References: <1352408373-25047-1-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Kees Cook wrote:

> This adds support for seccomp BPF to ARM. When built with the seccomp
> improvement patch waiting in linux-next ("seccomp: Make syscall skipping
> and nr changes more consistent"), this passes the seccomp regression
> test suite: https://github.com/redpig/seccomp

You should consider posting ARM specific patches to the ARM mailing list 
instead, where most people with an interest in reviewing those patches 
are listening: linux-arm-kernel@lists.infradead.org.


Nicolas
