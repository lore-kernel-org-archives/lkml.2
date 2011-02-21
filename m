Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1BUDl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:41:28 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41373 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1BUDlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:41:25 -0500
Date: Sun, 20 Feb 2011 22:41:22 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, Quentin Barnes <qbarnes@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in arm_kprobe_decode_insn
In-Reply-To: <20110220182437.GA24789@joi.lan>
Message-ID: <alpine.LFD.2.00.1102202239570.14920@xanadu.home>
References: <20110220182437.GA24789@joi.lan>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011, Marcin Slusarz wrote:

> Hi
> 
> In arch/arm/kernel/kprobes-decode.c there's a function arm_kprobe_decode_insn
> which does:
> 
> } else if ((insn & 0x0e000000) == 0x0c400000) {
> ...
> 
> This is always false, so code below is dead.

Good catch, thanks.


Nicolas
