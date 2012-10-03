Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2JCM1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:27:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2JCM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:27:40 -0400
Date: Wed, 3 Oct 2012 14:27:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: Add a workaround for GCC -mfentry
Message-ID: <20121003122738.GE16230@one.firstfloor.org>
References: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:17:07PM +0900, Masami Hiramatsu wrote:
> Add a workaround for GCC -mfentry option. This enables perf
> probe to find function parameters(arguments) at given function
> entry point again.

Could you please file a gcc PR about this?

-Andi
