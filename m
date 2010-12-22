Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0LVOdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:33:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:45303 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0LVOdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:33:17 -0500
Date: Wed, 22 Dec 2010 12:32:58 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip 2/4] [BUGFIX]perf: Fix strlist__parse_list to handle
 const string
Message-ID: <20101222143258.GA32740@ghostprotocols.net>
References: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
 <20101217131206.24123.87394.stgit@ltc236.sdl.hitachi.co.jp>
 <20101221182321.GA15683@ghostprotocols.net>
 <4D118543.3040007@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D118543.3040007@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 22, 2010 at 01:57:39PM +0900, Masami Hiramatsu escreveu:
> (2010/12/22 3:23), Arnaldo Carvalho de Melo wrote:
> > Em Fri, Dec 17, 2010 at 10:12:06PM +0900, Masami Hiramatsu escreveu:
> > Wouldn't be better to just stop changing the string by passing the
> > length to strlist__parse_list_entry, etc?
> 
> Yeah, it could be, but in that case, we need changing code
> wider.
> I think this is the simplest solution. :)

Ok, I'll try to fix it as I suggested, it it turns out difficult I'll
apply the minimal fix.
 
> (Of course, we have to check dupstr flag on top of strlist__load too.)
> 
> Thank you,

You're welcome,

- Arnaldo
