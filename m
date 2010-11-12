Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab0KLTOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:14:18 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:24147 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932757Ab0KLTOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:14:16 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gP0lfWYVM1lttI9NxgP0BWFGMJXZ9eRjQoO7JYLn.jy2.pu
 v.EGfdXX_EmhEO9Yebfz_JMdmToP0tm74qecWjE_rtK653Cfo2bILvV.fvYP
 ZCgkUGd2Lnsul7jGKx4FhbWSrOfil33MnWX6VHJsToZVdcYjt1iPHtFYfs0l
 Ldmh4d89Mm4N7d58XuOqHintfGaW7gr3cIPpPc0Dk9GZDDW.GrJpN3VYm8ny
 bZH6Y
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 12 Nov 2010 13:14:12 -0600 (CST)
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
In-Reply-To: <20101105195101.GC15561@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1011121313001.16754@router.home>
References: <1288975980.2882.877.camel@edumazet-laptop> <20101105102038.53e36f9e.akpm@linux-foundation.org> <1288980046.2882.1054.camel@edumazet-laptop> <20101105110828.52f061b3.akpm@linux-foundation.org> <1288981224.2882.1105.camel@edumazet-laptop>
 <20101105112821.57f80481.akpm@linux-foundation.org> <1288984844.2665.52.camel@edumazet-laptop> <20101105195101.GC15561@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prefetchw() would be too much overhead?



