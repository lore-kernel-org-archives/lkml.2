Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab0LMRrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:47:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:43043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab0LMRrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:47:41 -0500
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292261716.6803.332.camel@twins>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
	 <1291773285-16254-2-git-send-email-daahern@cisco.com>
	 <20101212201613.GA1784@nowhere> <4D06301C.2090309@cisco.com>
	 <20101213155451.GA1691@nowhere> <20101213164854.GL5407@ghostprotocols.net>
	 <20101213170923.GB1691@nowhere> <1292260289.6803.297.camel@twins>
	 <20101213171537.GC1691@nowhere> <1292260699.6803.305.camel@twins>
	 <20101213172216.GB7417@ghostprotocols.net>
	 <1292261716.6803.332.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 18:47:13 +0100
Message-ID: <1292262433.6803.351.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 18:35 +0100, Peter Zijlstra wrote:
>         * this CLOCK_MONOTONIC offset (for what little good that does, since
> our clock isn't strictly sync'ed to CLOCK_MONOTONIC so we can incur
> arbitrary drift). 

In fact, the only sane way to do that is by creating a software counter
that represents CLOCK_MONOTONIC and sample that say once a minute (or
more often if you want smaller drift).


