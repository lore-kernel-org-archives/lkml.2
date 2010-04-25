Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0DYSIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 14:08:23 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56353 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab0DYSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 14:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kBxPhjHUHjbIPWK2wg8sI3wD/6ass5sfXqEm8aUdhvYuylp0Gv65T2DmK/QJZx4ar1
         7qTv+plzsJdQE1mcVMzJnqJ2wPDf7CjzrQaYcOfyk3phaFOBq09xP7GrZgWPwSnXX7mP
         qtKUoptWL7GRQp1LrZ4AvbSrhr6Rkvd+3PKj8=
Date: Sun, 25 Apr 2010 20:08:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 8/9] perf: Add a perf trace option to check samples
	ordering reliability
Message-ID: <20100425180812.GE5375@nowhere>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com> <1272074742-3654-9-git-send-regression-fweisbec@gmail.com> <4BD31891.6080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD31891.6080508@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 12:13:05PM -0400, Masami Hiramatsu wrote:
> Hi Frederic,
> 
> Frederic Weisbecker wrote:
> > To ensure sample events time reordering is reliable, add a -d option
> > to perf trace to check that automatically.
> 
> Just out of curiosity, is there any possibility to add 
> other debugging options to perf-trace?
> If so, I think we can pass some arguments for
> this -d option, e.g. "-d ordering,events" and so on.
> Just an idea.
> 
> Thank you,



Sure, if somebody wants to come with another debugging option
in perf trace, no problem.

