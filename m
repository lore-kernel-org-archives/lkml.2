Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2FYAy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 20:54:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44876 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2FYAy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 20:54:58 -0400
X-AuditID: 9c930179-b7befae000006417-1d-4fe7b6de5322
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf dependency (v2)
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
	<1340358478.18025.51.camel@twins> <1340377510.1478.10.camel@leonhard>
	<4FE48CCA.2050506@gmail.com> <1340379000.1478.34.camel@leonhard>
	<4FE490C9.1020903@gmail.com> <20120622161449.GL17747@infradead.org>
	<4FE49C2D.3000509@gmail.com>
Date: Mon, 25 Jun 2012 09:51:00 +0900
In-Reply-To: <4FE49C2D.3000509@gmail.com> (David Ahern's message of "Fri, 22
	Jun 2012 10:24:13 -0600")
Message-ID: <87sjdkuscr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Fri, 22 Jun 2012 10:24:13 -0600, David Ahern wrote:
> On 6/22/12 10:14 AM, Arnaldo Carvalho de Melo wrote:
>> I think at least the .dymsym symbol table is present in DSOs, aka
>> libraries, otherwise how will they dynamicly link?
>>
> yes. I meant debug information wise - everything is stripped during
> packaging phase, so onbox analysis is severely limited in address to
> symbol resolutions.
>

Right, I was saying about a case of the onbox recording and off-line
analysis - I hope I didn't use vague words here. And I thought that
supporting build-id is helpful (not crucial, though) for the case too.

Thanks,
Namhyung
