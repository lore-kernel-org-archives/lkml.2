Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab0LMRs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:48:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:43079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab0LMRsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:48:54 -0500
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
Date: Mon, 13 Dec 2010 18:48:27 +0100
Message-ID: <1292262507.6803.355.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 18:35 +0100, Peter Zijlstra wrote:
> 
>  - extend the existing header infrastructure to write a new header in
> front of the new stream. The main header already has a data section that
> points to the end of the stream, add a continuation header section that
> points to a continuation-header used to appends and record the clock
> offset data in there. 

Also, if you want to add perf-stat functionality to perf-record you
could use something similar, a tail-header, and write the stat values in
there.

