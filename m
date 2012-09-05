Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828Ab2IEXHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:07:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39295 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750Ab2IEXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:06:59 -0400
Message-ID: <5047DB0F.8060902@gmail.com>
Date: Wed, 05 Sep 2012 17:06:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf: remove unneeded include of network header files
References: <1346255732-93246-1-git-send-email-dsahern@gmail.com> <20120905203903.GB8203@ghostprotocols.net> <5047C18B.9060602@gmail.com> <20120905223739.GE8203@ghostprotocols.net>
In-Reply-To: <20120905223739.GE8203@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/12 4:37 PM, Arnaldo Carvalho de Melo wrote:
>
> I fixed it already, nevermind, it was just a matter of reordering
> includes, think how fragil that is, but it works now.

tried that route too. I could not figure out the magic ordering, so 
punted on v2 of the patch leaving netdb.h in. Glad to see you figured 
out an ordering that works.

David

