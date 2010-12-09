Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0LID6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:58:21 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53334 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0LID6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:58:20 -0500
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 6/9] perf: session: Move dump code to event delivery path
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
In-reply-to: <20101207124550.918655066@linutronix.de>
References: <20101207124527.868085529@linutronix.de> <20101207124550.918655066@linutronix.de>
Date: Thu, 09 Dec 2010 14:58:13 +1100
Message-Id: <1291867040-sup-1823@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Thomas Gleixner's message of Tue Dec 07 12:48:55 UTC 2010:
> Subject: [patch 6/9] perf: session: Move dump code to event delivery path

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
