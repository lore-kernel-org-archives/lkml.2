Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2GULLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 07:11:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44284 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2GULLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 07:11:32 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Question] perf header: Why the HEADER_EVENT_DESC is needed?
Date: Sat, 21 Jul 2012 20:11:24 +0900
Message-ID: <87txx1qsgz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

I wonder why we need to save the event descriptions in the feature area
of file header. Since the perf_event_attr, its ids and the event name
are already saved in the header, it seems a duplicate work to do that.
For printing the information, we might reuse those info or evlist
directly IMHO.

Am I missing something?

Thanks,
Namhyung
