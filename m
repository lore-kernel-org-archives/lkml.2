Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0EKP4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:56:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:58739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0EKP4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:56:40 -0400
Date: Tue, 11 May 2010 12:56:11 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Subject: Re: [RFC] perf: perf record sets inherit by default
Message-ID: <20100511155611.GG19192@ghostprotocols.net>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
 <20100511150052.GE19192@ghostprotocols.net>
 <1273590800.1810.19.camel@laptop>
 <20100511155039.GF19192@ghostprotocols.net>
 <1273593131.1810.42.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273593131.1810.42.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 11, 2010 at 05:52:11PM +0200, Peter Zijlstra escreveu:
> On Tue, 2010-05-11 at 12:50 -0300, Arnaldo Carvalho de Melo wrote:
> 
> > Nope, see above. 
> 
> Ah, -p/-t might make sense to default to inherit off indeed.

That is what Stephane wanted in the first place, right?

- Arnaldo
