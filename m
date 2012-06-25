Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab2FYSo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:44:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61646 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab2FYSo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:44:56 -0400
Message-ID: <4FE8B1A4.9050704@gmail.com>
Date: Mon, 25 Jun 2012 12:44:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, psuriset@linux.vnet.ibm.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf kvm: fix segfault with default guest arguments
References: <1340599286-89757-1-git-send-email-dsahern@gmail.com> <20120625160847.GE30293@krava.brq.redhat.com>
In-Reply-To: <20120625160847.GE30293@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/12 10:08 AM, Jiri Olsa wrote:
>> perf's handling of default kallsyms and guest-modules needs to be reworked.
> agreed ;) any plans on that?

I am working on it as time allows. After debugging this latest data 
point (running longer avoid the segfault) I certainly understand the 
problem better, but the problem keeps expanding too -- like wrong paths 
on guest side modules. It really suggests that this notion of a 
'default' guest is just wrong - too little information. We'll see.

David
