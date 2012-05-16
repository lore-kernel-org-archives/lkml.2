Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab2EPBgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:36:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46362 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2EPBf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:35:57 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-20-4fb304779815
From: Namhyung Kim <namhyung.kim@lge.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH v2 0/5] perf tools: add meta-data header support in pipe mode
References: <1337081295-10303-1-git-send-email-eranian@google.com>
Date: Wed, 16 May 2012 10:34:01 +0900
In-Reply-To: <1337081295-10303-1-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Tue, 15 May 2012 13:28:10 +0200")
Message-ID: <87ehqkewom.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephane

On Tue, 15 May 2012 13:28:10 +0200, Stephane Eranian wrote:
> This patch series adds meta-data support to perf record/report in pipe
> mode:
> 	perf record -o - foo | perf inject -b | perf report -i -
>
> We had meta-data (information about host configuration, perf tool version,...)
> in regular (file) mode but it was lacking in pipe mode. This patch series fixes
> this.
>

In addition to this change, I think it'd be great if we keep this
meta-data somewhere for later use - I guess perf report and
annotate on TUI, at least, will need it too. Just a suggestion :).

Thanks,
Namhyung

