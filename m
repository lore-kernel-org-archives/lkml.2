Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1C1NqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:46:15 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:31955 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754266Ab1C1NqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:46:11 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 6FNEUdYVM1mbLGZWmsIdQwp1UGVftQW3pTkbmwR7.0reCEM
 1Okv5.9Nb9AIEG9vt0VhVFkSwYxo3dLrvy3gbN7EXnHzCpwBFAcxboLetmLp
 DX2hbH6jUNAAwmo0w5A926jNUPlP7_Wo0G_fXjJJrhEPvDEqGhwJsqNKu5ws
 G4MTH2HwkuKY6SLkO27T.rZyzouzECe2Po7n4OjLgnzZ5g1F8mHgreyGVgo9
 wSlcadV3GYD8Fsw4dDW2Vui_jxRs4mLlCDpJMBgcqGKgEVXnGQqzn0ZNGn5N
 Hs_sXss9TlpzZT3H1kx7cC.FDDNx5N1jZIic.iyyf8Zmu6EMx7SK89YUaTDK
 VLITxM6QqndazObt1sAn3oGbiYOPk
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 28 Mar 2011 08:46:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] percpu: avoid extra NOP in percpu_cmpxchg16b_double
In-Reply-To: <1301308335.3182.12.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103280845480.7590@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>  <20110324142146.GA11682@elte.hu>  <alpine.DEB.2.00.1103240940570.32226@router.home>  <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>  <20110324172653.GA28507@elte.hu> <20110324185258.GA28370@elte.hu>
  <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>  <20110324192247.GA5477@elte.hu>  <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>  <20110326112725.GA28612@elte.hu> <20110326114736.GA8251@elte.hu>  <1301161507.2979.105.camel@edumazet-laptop>
  <alpine.DEB.2.00.1103261406420.24195@router.home>  <alpine.DEB.2.00.1103261428200.25375@router.home>  <alpine.DEB.2.00.1103261440160.25375@router.home>  <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>  <alpine.DEB.2.00.1103262028170.1004@router.home>
  <alpine.DEB.2.00.1103262054410.1373@router.home>  <1301212347.32248.1.camel@edumazet-laptop> <1301308335.3182.12.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Eric Dumazet wrote:

> Therefore, NOPX should be :
>
> P6_NOP3 on SMP
> P6_NOP2 on !SMP

Acked-by: Christoph Lameter <cl@linux.com>
