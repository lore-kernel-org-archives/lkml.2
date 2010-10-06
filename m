Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0JFNpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:45:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:54137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab0JFNpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:45:30 -0400
Subject: Re: 2.6.36-rc5-mmotm0928 BUG while trying to ptrace a process
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, fweisbec <fweisbec@gmail.com>
In-Reply-To: <108598.1286357577@localhost>
References: <108598.1286357577@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Oct 2010 15:45:08 +0200
Message-ID: <1286372708.2144.183.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 05:32 -0400, Valdis.Kletnieks@vt.edu wrote:
> Dell Latitude E6500,  Intel Core2 Duo P8700 CPU.
> 
> Have seen this three times now while trying to attach gdb to a hung Firefox
> process.
> 
> [20669.480674] BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> [20669.480682] IP: [<ffffffff810b8275>] __reserve_bp_slot+0x56/0x17d

Known issue I think, Frederic was looking into curing this.

Frederic, what's the current status of that?
