Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0LHUZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:25:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33147 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0LHUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:25:08 -0500
Date: Wed, 8 Dec 2010 18:24:52 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/9]  perf: Consolidate the event handling and ordering
Message-ID: <20101208202452.GA14237@ghostprotocols.net>
Reply-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
References: <20101207124527.868085529@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207124527.868085529@linutronix.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 07, 2010 at 12:48:38PM -0000, Thomas Gleixner escreveu:
> The following series fixes an unbound array access and further
> consolidates the event handling in session.c.
> 
> It now allows:
> 
>    - time ordered dumps
>    - break time ordering when not all events provide timestamps

Hi Ian,

	Have you had the chance of reviewing/testing this patch series
so that we know that your needs are satisfied with it?

Thanks,

- Arnaldo
