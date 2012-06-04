Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2FDUko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:40:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2FDUkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:40:41 -0400
Message-ID: <1338842430.28282.136.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 22:40:30 +0200
In-Reply-To: <4FCCE823.8090700@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	     <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	    <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	   <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
	  <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
	 <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 09:53 -0700, Arjan van de Ven wrote:
> (I'll avoid the word "latency" here, since the real time people will
> then immediately think this is about controlling latency response, which
> it isn't) 

Note that if it is the synchronous thing, it is exactly that.
