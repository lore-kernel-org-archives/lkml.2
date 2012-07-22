Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2GVC2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 22:28:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63493 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2GVC2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 22:28:53 -0400
Message-ID: <500B6563.8090108@gmail.com>
Date: Sat, 21 Jul 2012 20:28:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/11] perf tool: give user better message if precise
 is not supported
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-11-git-send-email-dsahern@gmail.com> <87y5mdqtwe.fsf@kernel.org>
In-Reply-To: <87y5mdqtwe.fsf@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/12 4:40 AM, Namhyung Kim wrote:
> The name 'PEBS' is intel-specific, so shouldn't we try to avoid using it
> directly? How about this:
>
>      Precise event sampling is not supported. Try removing 'p' modifier

Your right. should keep the response consistent with the documentation 
which is generic. I'll wait for responses on the other patches; perhaps 
only have to respin this one.

David

