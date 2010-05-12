Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0ELNh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:37:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60694 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab0ELNh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GdvkA/xPeaybMiz6+XsDko64EYmofeaNbqFsndJAjgG+8h2pBsS95tFHfiT4ptmKQe
         qJnTQOTA4gJ2jLF4kA/v8wJ1dufo9uKsmcmQITr81+N2qxLt6TW310hY+Al4SlXcdB9L
         Oz7+6C6CojqzPmAGUaRbdd/VWwD837mAvo3nw=
MIME-Version: 1.0
In-Reply-To: <20100511213625.GD5422@nowhere>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
	 <20100511213625.GD5422@nowhere>
Date: Wed, 12 May 2010 15:37:27 +0200
Message-ID: <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
Subject: Re: [RFC] PyTimechart
From: Pierre Tardy <tardyp@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       mathieu.desnoyers@efficios.com, arjan@infradead.org,
       ziga.mahkovec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Plugging to the scripting API is really easy, run:
>
>        $ perf timechart record
>        $ sudo ./perf trace -g python
>        generated Python script: perf-trace.py

This is something that I want to try since I saw the perf scripting
patch, thanks for the recipe, I'll look at it in the next few days.

The next problem is that perf timechart record is frozen on the number
of event it records.
Pytimechart is able to display irq:* and workqueues:* events, as well
as trace_printks ( I dont know if perf is able to dump those )

I use trace_printk to mark the big traces with events I'm trying to debug.
Being able to look at ISR and workqueues is very useful, and there is
a special feature that warns when an ISR lasts more than 1ms.

For inclusion in mainline, this might take more time. The quality of
some portion of the code is far from being linux kernel's standards
:-}

Regards,
Pierre
