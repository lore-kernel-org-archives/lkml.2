Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0EKPwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:52:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0EKPwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:52:14 -0400
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
In-Reply-To: <20100511155039.GF19192@ghostprotocols.net>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
	 <20100511150052.GE19192@ghostprotocols.net>
	 <1273590800.1810.19.camel@laptop>
	 <20100511155039.GF19192@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 17:52:11 +0200
Message-ID: <1273593131.1810.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 12:50 -0300, Arnaldo Carvalho de Melo wrote:

> Nope, see above. 

Ah, -p/-t might make sense to default to inherit off indeed.

