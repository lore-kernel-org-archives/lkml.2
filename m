Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab2F1QPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:15:54 -0400
Received: from mail-yw0-f42.google.com ([209.85.213.42]:34346 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2F1QPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:15:53 -0400
X-Greylist: delayed 86285 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2012 12:15:53 EDT
Date: Thu, 28 Jun 2012 13:15:48 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/8] tools lib traceevent: Make dependency files
 regeneratable
Message-ID: <20120628161548.GB6211@infradead.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
 <1340343462-15556-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340343462-15556-3-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 22, 2012 at 02:37:36PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Ingo reported that libtraceevent doesn't clean out
> dependency (.d) files and it can cause a build error
> when the libgcc package upgraded:

Thanks, applied to perf/core.

- Arnaldo
