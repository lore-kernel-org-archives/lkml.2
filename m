Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2JRBjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:39:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43550 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab2JRBjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:39:52 -0400
X-AuditID: 9c930197-b7c4aae000004160-68-507f5de55e45
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 10/11] perf tools: Fix build on sparc.
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
	<1350494387-10987-11-git-send-email-acme@infradead.org>
Date: Thu, 18 Oct 2012 10:39:49 +0900
In-Reply-To: <1350494387-10987-11-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Wed, 17 Oct 2012 14:19:46 -0300")
Message-ID: <87txts1rtm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012 14:19:46 -0300, Arnaldo Carvalho de Melo wrote:
> From: David Miller <davem@davemloft.net>
>
> More UAPI stuff.

What about other architectures?  Don't they have the same problem?

Thanks,
Namhyung
