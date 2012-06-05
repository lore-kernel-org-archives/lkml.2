Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2FEP3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:29:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52201 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2FEP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:29:14 -0400
Message-ID: <4FCE25C6.2080601@gmail.com>
Date: Tue, 05 Jun 2012 09:29:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: git bisect and perf
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying find out when (ie. which commit) the pebs feature actually 
started working on a westmere system and hitting a problem with git-bisect:

# git bisect start arch/x86/kernel/cpu/perf_event*

# git bisect bad v2.6.35

# git bisect good v2.6.38
Some good revs are not ancestor of the bad rev.
git bisect cannot work properly in this case.
Maybe you mistake good and bad revs?

Any ideas on why git bisect would not work?

David
