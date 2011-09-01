Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1IARYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:24:55 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:44496
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043Ab1IARYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:24:54 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPVD:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 1 Sep 2011 13:24:46 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Hommey <mh@glandium.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Problem with perf hardware counters grouping
In-Reply-To: <alpine.DEB.2.00.1109011308430.9976@cl320.eecs.utk.edu>
Message-ID: <alpine.DEB.2.00.1109011322440.9976@cl320.eecs.utk.edu>
References: <20110831085718.GB13884@glandium.org>  <1314878012.11566.7.camel@twins>  <alpine.DEB.2.00.1109011117200.9976@cl320.eecs.utk.edu> <1314895312.1485.2.camel@twins> <alpine.DEB.2.00.1109011308430.9976@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Vince Weaver wrote:

> 
> Does the perf tool work around this in some way?  

oh I see, the perf tool, at least when using perf -e stat on multiple 
events, opens each event individually.  PAPI uses group leaders which is 
why we see the issue.

Vince
vweaver1@eecs.utk.edu

