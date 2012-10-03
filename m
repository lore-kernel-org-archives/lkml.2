Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2JCNMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:12:21 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37409 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2JCNMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:12:20 -0400
X-AuditID: b753bd60-928c4ba0000047ca-5a-506c39b1bb4c
X-AuditID: b753bd60-928c4ba0000047ca-5a-506c39b1bb4c
Message-ID: <506C39AF.9090001@hitachi.com>
Date: Wed, 03 Oct 2012 22:12:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: Add a workaround for GCC -mfentry
References: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp> <20121003122738.GE16230@one.firstfloor.org>
In-Reply-To: <20121003122738.GE16230@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/03 21:27), Andi Kleen wrote:
> On Wed, Oct 03, 2012 at 09:17:07PM +0900, Masami Hiramatsu wrote:
>> Add a workaround for GCC -mfentry option. This enables perf
>> probe to find function parameters(arguments) at given function
>> entry point again.
> 
> Could you please file a gcc PR about this?
> 

OK, filed as PR54793 :)
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=54793

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


