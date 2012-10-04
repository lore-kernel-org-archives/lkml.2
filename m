Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585Ab2JDIor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:44:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37800 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2JDIop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:44:45 -0400
Date: Thu, 4 Oct 2012 10:44:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf tools: Check existence of
 _get_comp_words_by_ref when bash completing
Message-ID: <20121004084430.GA3707@somewhere.redhat.com>
References: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
 <1349191294-6926-2-git-send-email-namhyung@kernel.org>
 <20121002155358.GD10605@somewhere>
 <87pq4zj9lk.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq4zj9lk.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 10:43:03AM +0900, Namhyung Kim wrote:
> Hi Frederic,
> 
> On Tue, 2 Oct 2012 17:54:10 +0200, Frederic Weisbecker wrote:
> > On Wed, Oct 03, 2012 at 12:21:32AM +0900, Namhyung Kim wrote:
> >> The '_get_comp_words_by_ref' function is available from the bash
> >> completion v1.2 so that earlier version emits following warning:
> >> 
> >>   $ perf re<TAB>_get_comp_words_by_ref: command not found
> >> 
> >> Use older '_get_cword' method when the above function doesn't exist.
> >
> > May be only use _get_cword then, if it works everywhere?
> 
> It'll work but it's deprecated.

Ok.
