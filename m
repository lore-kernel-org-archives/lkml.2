Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0KON5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:57:16 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:42705 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755672Ab0KON5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:57:14 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: uiOPs6QVM1nRJdrUXaXnfwpI0WPKqxOkxt3c8enr6y0JDxx
 oKzrApFPS04Kfjp2HuG1Lygi2x96sl6oVzYj2jVVIQezRLQLDFIHHRAhQ8MP
 Ma9_bi9T3CryYKgMGKMSJyQ25p6ewaCy7s1tnJJsUHkuF7DDmdoCBYw6FnET
 0fqILv7XyochnuwxgvALGSdX11S_hRWH9rPn85xHxZzdBXbDqJzjItmiQmdI
 ilIczRDCFms4-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 15 Nov 2010 07:57:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
In-Reply-To: <20101113222612.GD2825@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1011150756130.19175@router.home>
References: <1288975980.2882.877.camel@edumazet-laptop> <20101105102038.53e36f9e.akpm@linux-foundation.org> <1288980046.2882.1054.camel@edumazet-laptop> <20101105110828.52f061b3.akpm@linux-foundation.org> <1288981224.2882.1105.camel@edumazet-laptop>
 <20101105112821.57f80481.akpm@linux-foundation.org> <1288984844.2665.52.camel@edumazet-laptop> <20101105195101.GC15561@linux.vnet.ibm.com> <alpine.DEB.2.00.1011121313001.16754@router.home> <20101113222612.GD2825@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010, Paul E. McKenney wrote:

> On Fri, Nov 12, 2010 at 01:14:12PM -0600, Christoph Lameter wrote:
> >
> > prefetchw() would be too much overhead?
>
> No idea.  Where do you believe that prefetchw() should be added?

It is another way to get an exclusive cache line
for situations like this. No need to give a hint.

