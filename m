Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1DAUVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:21:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1DAUVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:21:00 -0400
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>
In-Reply-To: <4D96072E.4060902@gmail.com>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
	 <20110324113209.20235.61900.stgit@localhost6.localdomain6>
	 <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com>
	 <4D8CAE74.9080805@gmail.com> <4D906450.1040809@hitachi.com>
	 <4D909BBB.5020500@gmail.com> <20110401151313.GC2335@nowhere>
	 <4D96072E.4060902@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 22:20:43 +0200
Message-ID: <1301689243.2221.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 11:11 -0600, David Ahern wrote:
> 
> There is another email thread about page faults. The user wants sample
> address resolved to symbols. I was going to look into it next week when
> I get back from vacation. 

I know Anton played around with something like that a while back, maybe
he can share.
