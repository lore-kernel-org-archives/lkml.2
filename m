Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1IBSCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:02:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63577 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1IBSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:02:50 -0400
Date: Fri, 2 Sep 2011 15:02:42 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 1/2] perf stat: add -l <N> option to redirect stderr
 elsewhere
Message-ID: <20110902180242.GB17970@ghostprotocols.net>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-2-git-send-email-jim.cromie@gmail.com>
 <20110521103418.GB23651@elte.hu>
 <20110521204148.GB10330@ghostprotocols.net>
 <CAJfuBxzhjhuGRfqW-qXFhNN+X6n_puaVS+-AbZN2NjUQGou3Jw@mail.gmail.com>
 <20110902143549.GA17970@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902143549.GA17970@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 02, 2011 at 11:35:49AM -0300, Arnaldo Carvalho de Melo escreveu:
> I'll look at the other 3 patch series that came after, will fix up and
> post here for your consideration.

Can you try to rehash those? Ingo added a series of patches to print
other metrics (stalled cycles frontend, etc) and the changes require
some more work, if you could work on it I'd appreciate.

Again, sorry for not having merged this sooner, avoiding this work now.

- Arnaldo
