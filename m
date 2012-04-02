Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2DBWSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:18:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59724 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab2DBWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:18:21 -0400
Message-ID: <4F7A2592.1060102@zytor.com>
Date: Mon, 02 Apr 2012 15:17:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH -tip 00/16] in-kernel x86 disassember
References: <20120401160229.4502.2541.stgit@shimauta> <20120402070446.GA12689@gmail.com>
In-Reply-To: <20120402070446.GA12689@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 12:04 AM, Ingo Molnar wrote:
> Perf could use 
> a programmatic, librarized disassembler for its assembly 
> annotation code.

BTW, it should be pretty trivial to librarize the disassembler from
NASM.  Even more so, I think this might have already been done with Yasm.

	-hpa

