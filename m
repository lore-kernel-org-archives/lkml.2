Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2E3RcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:32:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63808 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab2E3RcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:32:06 -0400
Message-ID: <4FC65991.7000602@gmail.com>
Date: Wed, 30 May 2012 11:32:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: Re: [PATCH] perf script: fix regression in dso name
References: <1338353906-60706-1-git-send-email-dsahern@gmail.com> <20120530172724.GC12477@infradead.org>
In-Reply-To: <20120530172724.GC12477@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/12 11:27 AM, Arnaldo Carvalho de Melo wrote:
>
> Thanks, reproduced, tested and pushed to perf/urgent.
>
> Unfortunately saw this after the last pull req, will include it in the
> next if Ingo pulls from the signed tag instead of perf/urgent.
>
> - Arnaldo

broken in v3.3 too.

David
