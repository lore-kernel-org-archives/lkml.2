Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0FSOR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:17:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45800 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0FSOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:17:26 -0400
Date: Sat, 19 Jun 2010 16:17:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100619141724.GN18946@basil.fritz.box>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <1276862130.1875.7.camel@laptop>
 <20100618122532.GB9045@basil.fritz.box>
 <20100618143749.GA14034@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618143749.GA14034@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nope - the softirq code was written by Alexey Kuznetsov and David S. Miller. 

It was based on the design of the previous bottom halves in case you
missed it. I believe BHs were there from nearly the beginning.

(softirqs were basically just per cpu bottom halves, otherwise
being very similar)

-Andi
