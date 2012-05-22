Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab2EVAWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:22:51 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51092 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2EVAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:22:50 -0400
X-AuditID: 9c93016f-b7c3cae000001954-3a-4fbadc56f032
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC 0/5] perf tools: Minimalistic build without libelf dependency
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
	<87mx522huw.fsf@sejong.aot.lge.com> <4FBA5937.2050701@gmail.com>
Date: Tue, 22 May 2012 09:20:42 +0900
In-Reply-To: <4FBA5937.2050701@gmail.com> (David Ahern's message of "Mon, 21
	May 2012 09:03:19 -0600")
Message-ID: <87aa112hid.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Mon, 21 May 2012 09:03:19 -0600, David Ahern wrote:
> One idea that has been proposed is to make perf configurable - to pick
> and choose which pieces you want built-in. For example for target
> systems only compile in record command. It seems like that part should
> be done first and would potentially handle a lot of these changes.
>

Yeah, I remember Arnaldo said about the menuconfig-like configuration
interface. But I'd like to finish this minimal build patchset first
since the configuration change can require much work on where I'm not
familiar with and I doubt the users care about it much.

Anyway, thanks for the comment.
Namhyung
