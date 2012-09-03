Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2ICBOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:14:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55989 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab2ICBOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:14:39 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-2c-5044047b1352
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 08/13] perf tools: Use __maybe_used for unused variables
References: <CANg8OWKxb_sMXSSpf0iHVn4+a8QF1-b1cKX+jBiWzBYamGNjrw@mail.gmail.com>
Date: Mon, 03 Sep 2012 10:07:00 +0900
In-Reply-To: <CANg8OWKxb_sMXSSpf0iHVn4+a8QF1-b1cKX+jBiWzBYamGNjrw@mail.gmail.com>
	(Irina Tirdea's message of "Wed, 29 Aug 2012 01:04:25 +0300")
Message-ID: <87392zgbij.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 29 Aug 2012 01:04:25 +0300, Irina Tirdea wrote:
> perf defines __used to for marking unused variables.
> The variable __used is defined to __attribute__((__unused__)), which
> contradicts the kernel definition to __attribute__((__used__))
> for new gcc versions. On Android), __used is also defined in
> system headers and this leads to warnings like:
> warning: '__used__' attribute ignored
>
> This patch simply replaces all instances of __used with __maybe_unused
> so there will be no such warnings.

How about just using '__unused' for less typing?

Btw, the patch looks whitespace-damaged.

Thanks,
Namhyung
