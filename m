Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0DDXXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 19:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab0DDXXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 19:23:42 -0400
Date: Sun, 4 Apr 2010 20:23:23 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Swap including order of util.h and string.h of
	util/string.c
Message-ID: <20100404232323.GD27773@ghostprotocols.net>
References: <1270368798-27232-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100404143441.GA5608@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100404143441.GA5608@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Apr 04, 2010 at 04:34:43PM +0200, Frederic Weisbecker escreveu:
> On Sun, Apr 04, 2010 at 05:13:18PM +0900, Hitoshi Mitake wrote:
> > Current util/string.c includes headers in this order: string.h, util.h
> > But this causes build error because __USE_GNU definition
> > is needed for strndup() definition like this,
> > % make -j
> > touch .perf.dev.null
> >     CC util/string.o
> > cc1: warnings being treated as errors
> > util/string.c: In function ‘argv_split’:
> > util/string.c:171: error: implicit declaration of function ‘strndup’
> > util/string.c:171: error: incompatible implicit declaration of built-in function ‘strndup’
> 
> Thanks, I've queued it as I have the same problem and I'm
> about to send a perf/core queue.

Sorry about that and thanks for queueing it up, keeping this tempo of
getting patches queued up and pushed up upstream for perf is really nice
inasmuch as we keep it sane, and so far I think it is really being
excellent! :-)

- Arnaldo
