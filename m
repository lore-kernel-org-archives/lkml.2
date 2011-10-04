Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab1JDUDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:03:44 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:20815 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933550Ab1JDUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:03:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5wI3UgsVM1ku7mR6mOnRhu5xXy1ZGKJDPmw_QUeQCY7kCFC
 iwJVSZXSgC6PUWJVpCtHxSXOGX.g09_mJ1XZ5cf.yhyEI6AWWmVAGQpLZnH4
 Pdgn4Hha1LrSDZmjKYAy47Mck6qs5pu_WFiCG2fqjwPNXbdyU.rAa7CQsm7S
 lfKrNENlprtdXMhq5DRxmlrEzIOpyDRO65OfpfH_5Rbop4oEhOz7SC2M10Jv
 8t6f6L0Gr.cSa1S_TNJvI0hQmROn6TehW3l0g.h1aiJlGkODoJLeLDgfo5c0
 Nu7r4ieaYdqlnfA7uKmwSTDZEMtSRxFam0GNx4KxTeIPCc5MYIbLDjL1Eoq0
 9s_hv_c95qHpKqbNZCPuXr_.PSunHbsISAuDMsmffoA0ifl70EQalwPz5B9N
 m8SE43lRIR0FK44d902AVp7s0HdzBqoh.ZGOe
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 4 Oct 2011 15:03:38 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
cc: Joe Perches <joe@perches.com>, starlight@binnacle.cx,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
In-Reply-To: <874nzo35bu.fsf@depni.sinp.msu.ru>
Message-ID: <alpine.DEB.2.00.1110041501130.16183@router.home>
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx> <alpine.DEB.2.00.1110041358500.12199@router.home> <1317757118.3580.24.camel@Joe-Laptop> <alpine.DEB.2.00.1110041442020.15871@router.home> <874nzo35bu.fsf@depni.sinp.msu.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011, Serge Belyshev wrote:

>
> Christoph Lameter <cl@gentwo.org> writes:
> > No. BFS has no NUMA support.
>
> BFS has NUMA support since v0.300, 1st oct. 2009.

>From the BFS FAQ (lack of NUMA support causes additional memory latencies,
the high end business server these days have NUMA):

NUMA aware?

It is NOT NUMA aware in the sense that it does any fancy shit on NUMA, but
it will work on NUMA hardware just fine. Only the really big NUMA hardware
is likely to suffer in performance, and this is theoretically only, since
no one has that sort of hardware to prove it to me, but it seems almost
certain. v0.300 onwards have NUMA enhancements.

