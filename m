Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2EVHxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:53:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:50484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2EVHxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:53:15 -0400
Message-ID: <1337673178.9698.0.camel@twins>
Subject: Re: [PATCH 5/5] perf symbols: Implement poor man's ELF parser
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 May 2012 09:52:58 +0200
In-Reply-To: <20120521114739.GC5923@m.brq.redhat.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
	 <1336979424-17206-6-git-send-email-namhyung.kim@lge.com>
	 <20120521114739.GC5923@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 13:47 +0200, Jiri Olsa wrote:
> I can see all this exported in:
> 
> [jolsa@dhcp-26-214 perf]$ rpm -qf /usr/include/elf.h
> glibc-headers-2.14.90-24.fc16.6.x86_64
> 
> so maybe we dont need to add our own, since glic-headers
> seems crutial anyway ;) 

There's people building perf against uclibc and such, not sure they
carry it.
