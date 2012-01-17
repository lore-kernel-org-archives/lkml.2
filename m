Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab2AQQEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:04:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42008 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2AQQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:04:13 -0500
Message-ID: <4F159BF7.7040307@gmail.com>
Date: Tue, 17 Jan 2012 09:04:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v4 4/5] perf script: add the offset field specifier
References: <20120116052146.2485.48349.stgit@linux3> <20120116052228.2485.65259.stgit@linux3>
In-Reply-To: <20120116052228.2485.65259.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2012 10:22 PM, Akihiro Nagai wrote:
> Add the offset field specifier 'offs' to show the offset from
> the symbols in the output of perf-script. We can get the more
> detailed address information.
> 
> Output sample:
> # perf script -f ip,addr,sym,offs
> 301ec016b0            _start+0x0 ffffffff81467612 irq_return+0x0
> 301ec016b0            _start+0x0 ffffffff81467612 irq_return+0x0
> 301ec04b70         _dl_start+0x0       301ec016b3 _start+0x3
> 301ec04b70         _dl_start+0x0 ffffffff81467612 irq_return+0x0
> 301ec04b96        _dl_start+0x26 ffffffff81467612 irq_return+0x0
> 301ec04b9d        _dl_start+0x2d ffffffff81467612 irq_return+0x0
> 301ec04c0d        _dl_start+0x9d       301ec04beb _dl_start+0x7b
> 301ec04bf0        _dl_start+0x80       301ec04c11 _dl_start+0xa1
> [snip]
> 
> Changes in v2:
>  - change the way to output offset from '--show-symbol-offset' to
>    'offs' field.
>  - clean up codes.
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
