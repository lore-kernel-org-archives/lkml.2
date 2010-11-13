Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0KMW0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:26:32 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60301 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab0KMW03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:26:29 -0500
Date: Sat, 13 Nov 2010 14:26:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
Message-ID: <20101113222612.GD2825@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1288975980.2882.877.camel@edumazet-laptop>
 <20101105102038.53e36f9e.akpm@linux-foundation.org>
 <1288980046.2882.1054.camel@edumazet-laptop>
 <20101105110828.52f061b3.akpm@linux-foundation.org>
 <1288981224.2882.1105.camel@edumazet-laptop>
 <20101105112821.57f80481.akpm@linux-foundation.org>
 <1288984844.2665.52.camel@edumazet-laptop>
 <20101105195101.GC15561@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1011121313001.16754@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011121313001.16754@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 01:14:12PM -0600, Christoph Lameter wrote:
> 
> prefetchw() would be too much overhead?

No idea.  Where do you believe that prefetchw() should be added?

							Thanx, Paul
