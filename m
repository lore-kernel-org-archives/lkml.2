Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0EUKDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:03:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0EUKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:03:34 -0400
Subject: Re: [PATCH 05/10] perf-record: Share per-cpu buffers
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521094434.GB30108@nowhere>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.634824884@chello.nl>  <20100521094434.GB30108@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 12:03:30 +0200
Message-ID: <1274436210.1674.1691.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 11:44 +0200, Frederic Weisbecker wrote:

> If you do this multiplex per cpu (which I think is a very good thing), you
> should also increase the default value of mmap_pages as it might not be big
> enough anymore. 

Hmm, I didn't notice any problems with that.

