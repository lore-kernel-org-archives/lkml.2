Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab0EROJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:09:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab0EROJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:09:24 -0400
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100518133726.214318408@chello.nl>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 May 2010 16:09:01 +0200
Message-ID: <1274191741.5605.8010.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 15:33 +0200, Peter Zijlstra wrote:

> +#define PO_NOWAKE		0x01	/* can't do wakeups        */
> +#define PO_SAMPLE		0x02	/* is a PERF_RECORD_SAMPLE */
> +#define PO_LINEAR		0x03	/* linear addressable      */

D'0h, /me gives himself the moron-award...
