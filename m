Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2F0QZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:25:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64083 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2F0QZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:25:48 -0400
Date: Wed, 27 Jun 2012 13:17:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2] perf bench: Documentation update
Message-ID: <20120627161744.GB3878@infradead.org>
References: <1340172486-17805-1-git-send-email-namhyung@kernel.org>
 <CAMO-S2gfK2dMzLX-jO5LqjTPos7YjtHAbN_oQiw2LQfGBfLMsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMO-S2gfK2dMzLX-jO5LqjTPos7YjtHAbN_oQiw2LQfGBfLMsQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 25, 2012 at 12:46:12AM +0900, Hitoshi Mitake escreveu:
> On Wed, Jun 20, 2012 at 3:08 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> >
> > The current perf-bench documentation has a couple
> > of typos and even lacks entire description of mem
> > subsystem. Fix it.
> 
> Really sorry for my bad English... and thanks for your fix!
> Acked-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

Thanks, applied to my perf/core branch.

- Arnaldo
