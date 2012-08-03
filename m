Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2HCPYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:24:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39685 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2HCPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:24:30 -0400
Message-ID: <501BED28.30208@gmail.com>
Date: Fri, 03 Aug 2012 09:24:24 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/18] perf evlist: Introduce perf_evlist__parse_sample
References: <1344002470-5965-1-git-send-email-acme@infradead.org> <1344002470-5965-9-git-send-email-acme@infradead.org>
In-Reply-To: <1344002470-5965-9-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/12 8:01 AM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> That is a more compact form of perf_session__parse_sample and to support
> multiple evlists per perf_session is the way to go anyway.

So then all events in an evlist will have the same sample type? If you 
want different sample types (at some point in the future) you will have 
to create separate evlists?

David

