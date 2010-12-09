Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0LID4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:56:38 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47705 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0LID4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:56:37 -0500
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/9] perf: session: Store file offset in sample_queue
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
In-reply-to: <20101207124550.725128545@linutronix.de>
References: <20101207124527.868085529@linutronix.de> <20101207124550.725128545@linutronix.de>
Date: Thu, 09 Dec 2010 14:56:30 +1100
Message-Id: <1291866899-sup-8434@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Thomas Gleixner's message of Tue Dec 07 12:48:50 UTC 2010:
> Subject: [patch 4/9] perf: session: Store file offset in sample_queue

Looks the same as mine, so:

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
