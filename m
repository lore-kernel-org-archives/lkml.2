Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1GJLA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:00:57 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61546 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1GJLAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:00:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110710100012.2550.4040.stgit@fedora15>
References: <20110710100005.2550.83138.stgit@fedora15>
	<20110710100012.2550.4040.stgit@fedora15>
Date: Sun, 10 Jul 2011 14:00:52 +0300
X-Google-Sender-Auth: 2yWB8BDSWb8p-dE5lj91-C1zLeU
Message-ID: <CAOJsxLGUPYi89zY2HC47ar5OzqTbFY=G=66f8heq5zUCkyeFmg@mail.gmail.com>
Subject: Re: [PATCH -tip 1/5] [BUGFIX] perf-probe: Fix a memory leak for
 scopes array
From: Pekka Enberg <penberg@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 1:00 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Fix a memory leak for scopes array when it finds a
> variable in the global scope.
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
