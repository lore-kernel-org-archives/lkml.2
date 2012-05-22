Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2EVK2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:28:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46570 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2EVK2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:28:31 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-1b-4fbb6a4cf238
From: Namhyung Kim <namhyung.kim@lge.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] perf symbols: Implement poor man's ELF parser
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
	<1336979424-17206-6-git-send-email-namhyung.kim@lge.com>
	<20120521114739.GC5923@m.brq.redhat.com>
	<1337673178.9698.0.camel@twins>
Date: Tue, 22 May 2012 19:26:27 +0900
In-Reply-To: <1337673178.9698.0.camel@twins> (Peter Zijlstra's message of
	"Tue, 22 May 2012 09:52:58 +0200")
Message-ID: <87sjes1pgs.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 22 May 2012 09:52:58 +0200, Peter Zijlstra wrote:
> On Mon, 2012-05-21 at 13:47 +0200, Jiri Olsa wrote:
>> I can see all this exported in:
>> 
>> [jolsa@dhcp-26-214 perf]$ rpm -qf /usr/include/elf.h
>> glibc-headers-2.14.90-24.fc16.6.x86_64
>> 
>> so maybe we dont need to add our own, since glic-headers
>> seems crutial anyway ;) 
>
> There's people building perf against uclibc and such, not sure they
> carry it.

I've checked uclibc and it provides elf.h also. It seems bionic does too.
(do we care?)

Thanks,
Namhyung
