Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0LIDzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:55:01 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38071 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0LIDzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:55:00 -0500
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 3/9] perf: session: Consolidate the dump code
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
In-reply-to: <20101207124550.625434869@linutronix.de>
References: <20101207124527.868085529@linutronix.de> <20101207124550.625434869@linutronix.de>
Date: Thu, 09 Dec 2010 14:54:53 +1100
Message-Id: <1291866638-sup-9440@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Thomas Gleixner's message of Tue Dec 07 12:48:47 UTC 2010:
> The dump code used by perf report -D is scattered all over the
> place. Move it to separate functions.

It's cleaner than my patch, and does the same thing, so:

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
