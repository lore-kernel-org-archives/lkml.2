Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1CJPgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:36:09 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:33237 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753123Ab1CJPgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:36:07 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .sistOQVM1kNoVltIUQWsrWynQ8MIRHJN5MoGqkguQ7G.Im
 keiNjv.K8T5bxT7FGpwx_zcRmJnTl3EPQG1qq470J0GOY408PPmcLRvp1y8W
 yjYL0a_u0fo6kP7CGkI4cc.oUmvQO03TXUcqQTg5GKioUdZuVwTtLQOhNZCt
 3GuCnzgQQZScwrCWKjnQOtjOTL2A8r1vpHPczKPc7y5DGB3KMhHCpS16UeNG
 ZwIN3pynEn4PZc6DVegVfYjh77WniX6bf45TVHrCAu4hNewAYYPRuCxYHnqN
 82OSWGI6E3geQdleuLJJzuQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 10 Mar 2011 09:36:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3 V2] slub,rcu: don't assume the size of struct
 rcu_head
In-Reply-To: <4D787C18.3070800@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1103100935390.30899@router.home>
References: <4D6CA843.3090103@cn.fujitsu.com> <4D787C18.3070800@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Lameter <cl@linux.com>

