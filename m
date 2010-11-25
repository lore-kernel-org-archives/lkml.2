Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab0KYIAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:00:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46174 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0KYIAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:00:15 -0500
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to
 "perf stat"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <20101125074629.GC2538@nowhere>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
	 <1290666760.2072.539.camel@laptop>  <20101125074629.GC2538@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 09:00:09 +0100
Message-ID: <1290672009.2072.558.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 08:46 +0100, Frederic Weisbecker wrote:
> > perf record -e task-clock:freq=1000,cycles:period=0
> 
> Wouldn't this syntax clash with the flags we have on events already?
> 
> the u,k,p flags? 

>From stephane's email (to which you were CC'ed) http://lkml.org/lkml/2010/11/23/303

> $ perf record -e cycles:u:period=100000,instructions:k:freq=1500 -a -- sleep 5

The parser isn't particularly pretty, maybe its time to think about a parser generator?
