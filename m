Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab2EVKo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:44:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40278 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2EVKoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:44:55 -0400
Message-ID: <1337683484.9698.10.camel@twins>
Subject: Re: [PATCH 5/5] perf symbols: Implement poor man's ELF parser
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 May 2012 12:44:44 +0200
In-Reply-To: <87sjes1pgs.fsf@sejong.aot.lge.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
	 <1336979424-17206-6-git-send-email-namhyung.kim@lge.com>
	 <20120521114739.GC5923@m.brq.redhat.com> <1337673178.9698.0.camel@twins>
	 <87sjes1pgs.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 19:26 +0900, Namhyung Kim wrote:
> I've checked uclibc and it provides elf.h also. It seems bionic does too.
> (do we care?) 

We should (care), it would be very nice if embedded could also run perf.

IIRC we get the occasional build fix from them as well which means
people are in fact using this.
