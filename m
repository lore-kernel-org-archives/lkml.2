Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2LDNzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:55:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab2LDNzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:55:17 -0500
Date: Tue, 4 Dec 2012 14:54:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/3] perf hists: Changes on hists__{link,match}
Message-ID: <20121204135454.GA1041@krava.brq.redhat.com>
References: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 01:44:22PM +0900, Namhyung Kim wrote:
> Hi Arnaldo,
> 
> This is what I talked to Jiri yesterday, and it can be a common basis
> of both event group and multiple diff patchset.  The point is using
> internal input or collapsed rb tree to sort hist entries rather than
> output tree with unnessary resort.
> 
> Please take a look.
> 
> Thanks,
> Namhyung
> 
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> 
> Namhyung Kim (3):
>   perf hists: Exchange order of comparing items when collapsing hists
>   perf hists: Link hist entries before inserting to an output tree
>   perf diff: Use internal rb tree for compute resort
hi,
could you please push branch with this?

thanks,
jirka
