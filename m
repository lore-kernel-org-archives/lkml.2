Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1GDLv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:51:58 -0400
Received: from ozlabs.org ([203.10.76.45]:54177 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1GDLv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:51:57 -0400
Date: Mon, 4 Jul 2011 21:51:40 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf report/annotate: Add option to specify a CPU range
Message-ID: <20110704215140.01b5ecaa@kryten>
In-Reply-To: <20110701111641.GE20990@elte.hu>
References: <20110629150739.49b25604@kryten>
	<4E0B69EC.70009@gmail.com>
	<20110630131639.253c6529@kryten>
	<4E0BF3D0.4010405@gmail.com>
	<20110701111641.GE20990@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Ingo Molnar <mingo@elte.hu> wrote:

> * David Ahern <dsahern@gmail.com> wrote:
> > It would be better to make this a function that all 3 commands 
> > reference -- something like perf_session__cpu_bitmap(session, 
> > cpu_list, cpu_bitmap) in util/session.c
> 
> Agreed. I can see how it ended up looking like this (fixing only perf 
> report, then adding it to top, then to script), but at this stage it 
> really calls for one helper that all three commands can utilize.

Yeah, it was dying to be consolidated. New version on the way.

> Very nice enhancement otherwise - might i suggest a 'perf top' hotkey 
> as well to limit the output to certain CPUs only? :-)

Good idea :) I'll have a go at it.

Anton
