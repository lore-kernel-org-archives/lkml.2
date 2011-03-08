Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1CHS1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:27:19 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:23180 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752670Ab1CHS1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:27:16 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SGhezzoVM1mZSdlckLs2vomkjwVe2eOAnbcjjfVeyfJjFVk
 yuE7CfHL9hE45L46nAty9nlzezCiRskZAnkVPofxHKC01psVkZ7BGwuxGIH.
 VThWf6p1bZEoUC5intuohnEFZNNbLRiPavQQ9G973_I_F4d9KoyoUqYdwmSr
 TAzPveASc1TIY3QSYXPqQ7VTk3I8vrw6V75JIIPOgAlNSvuXY.e2YqVYbfG6
 ._026M3SguKOF5bmMycBibTcxEEjXjnBbqmeUexP3WF2p6OCtCjfMtIgBArf
 CI6QUScyG9chyrAp3Faa2RRnF3O7jTW8EnkWXZqiCKuTp8PzSv6Eu6phfa_0
 keFmBrsuCRN0ruxZZXSFrgl9c556bX9D8nkJwxDcx6R.5uyKDGOk0QY.wfst
 i7yNruUr0_T.MR.OHU4QXEu7YN4mE0uGT2zOkV87aWuJZacTDNYMWajgvA7M
 B2o6PfcxS.T7TTV._92NWZiFuHnnj0cq4Nm7bK2cKCN7w2Y1pDqyIeKzssyF
 MwHvue1ulK3YcP7zl9w--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 8 Mar 2011 12:27:11 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] slab,rcu: don't assume the size of struct rcu_head
In-Reply-To: <4D6CA85B.5030107@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1103081226530.25214@router.home>
References: <4D6CA85B.5030107@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux.com>

