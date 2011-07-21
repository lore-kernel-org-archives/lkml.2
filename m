Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1GUJnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:43:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:50241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1GUJnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:43:05 -0400
Subject: Re: [PATCH -tip v2 2/6] perf script: add magic word to indicate
 the failure of resolving symbols
From: Peter Zijlstra <peterz@infradead.org>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
In-Reply-To: <4E27F32A.6010609@hitachi.com>
References: <20110717093031.3447.52715.stgit@linux3>
	 <20110717093051.3447.65080.stgit@linux3> <4E2308A9.5000706@gmail.com>
	 <4E230E32.3010503@gmail.com>  <4E27F32A.6010609@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 11:42:18 +0200
Message-ID: <1311241338.29152.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 18:36 +0900, Akihiro Nagai wrote:
> In addition, perf uses "[]" for DSO name for example
> "[kernel.kallsyms]".

We only use that for kernel dsos iirc.
