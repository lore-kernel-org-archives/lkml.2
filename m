Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2JZRUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:20:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35397 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab2JZRUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:20:22 -0400
Date: Fri, 26 Oct 2012 19:20:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>, Borislav Petkov <bp@amd64.org>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121026172018.GA14116@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
	Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
	Andrew Vagin <avagin@openvz.org>, Borislav Petkov <bp@amd64.org>,
	David Howells <dhowells@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Stephane Eranian <eranian@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <508AA709.7010202@gmail.com>
 <1351265502.1619.13.camel@leonhard>
 <20121026153431.GA5230@x1.osrc.amd.com>
 <20121026163115.GA20695@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121026163115.GA20695@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 09:31:15AM -0700, Arnaldo Carvalho de Melo wrote:
> Right, perf'ing perf is a favourite pastime, right?

Sure, can I get "perfing perf" on a T-shirt please?

-- 
Regards/Gruss,
    Boris.
