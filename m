Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2GKCUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 22:20:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46481 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2GKCUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 22:20:16 -0400
Message-ID: <4FFCE2DC.1090201@gmail.com>
Date: Tue, 10 Jul 2012 20:20:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhang <bookjovi@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix perf-lock report coredump
References: <CACV3sbK7jUCDZxGBs3RUYnQ4s+VyEt7VYeRKD50F07zZrYKgCg@mail.gmail.com>
In-Reply-To: <CACV3sbK7jUCDZxGBs3RUYnQ4s+VyEt7VYeRKD50F07zZrYKgCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/12 7:06 PM, Jovi Zhang wrote:
>  From 4b363bf16c12b76788fbace1475123b7214ae58d Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Wed, 11 Jul 2012 16:53:57 +0800
> Subject: [PATCH] perf: fix perf-lock report coredump
>
> Check sample type event raw_data is existed in perf.data firstly,
> then invoke process_raw_event, otherwise it will coredump.

Does this fix it for you:
http://lkml.org/lkml/2012/7/6/405

Also does 'perf lock record' work for you? If so can you send me your 
kernel config file?

Thanks,

David
