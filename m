Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1AMVYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:24:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60676 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab1AMVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:24:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=dl2PL+VVD7XS+r1x9R2vHQdh1iEawqzokINclTL6Pwz5gMfiPrCnzVIIidCvQFNtFy
         FJ3WUlVXK57bcd5Ef3JiXjdZxuHK9XiHbi2CPF7cg7NCBYG9Iss8p//MjCPRpzf7CQ5K
         8/38rd9tB61HgAT9QJrkaOuLGAXpNAXaC6n+8=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -perf/perf/core 3/6] perf probe: Add --funcs to show available functions in symtab
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
	<20110113124611.22426.10835.stgit@ltc236.sdl.hitachi.co.jp>
Date: Thu, 13 Jan 2011 22:24:27 +0100
In-Reply-To: <20110113124611.22426.10835.stgit@ltc236.sdl.hitachi.co.jp>
	(Masami Hiramatsu's message of "Thu, 13 Jan 2011 21:46:11 +0900")
Message-ID: <m3sjww7b04.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

[...]

>  tools/perf/builtin-probe.c    |   29 +++++++++++++++++-
>  tools/perf/util/probe-event.c |   67 ++++++++++++++++++++++++++++++++++++++++-
>  tools/perf/util/probe-event.h |    1 +
>  3 files changed, 94 insertions(+), 3 deletions(-)

"tools/perf/Documentation/perf-probe.txt" is missing ;)

-- 
		Franck
