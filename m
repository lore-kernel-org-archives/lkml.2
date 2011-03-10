Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1CJPgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:36:35 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:38970 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753090Ab1CJPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:36:33 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mROzG8sVM1lfs5ii372KVxIcSeIN6dIjAK_qJQBJvC0LqD7
 rc.0Bv2QswuBT3_LCVmDf0Fn_YcBQFtEvxbu69X5HgdzYRnz17qBxWJ.mzxE
 zjwQKD.NIQKMWiVTYGSPVWpo7.HxHdZ1azqw22Cnmbypan.AtHD3d9MyOe3l
 c3dV218ZHph6tps8WcWbtDKu7YGN3FY9fpwONx64WIzzJPtZisgcDo56xl73
 dfc1P.vcR137lg0Lm7yOa9.3f0v_1Rt7D.Rm9g3x3PWpeTA--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 10 Mar 2011 09:36:28 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3 V2] slab,rcu: don't assume the size of struct
 rcu_head
In-Reply-To: <4D787C30.1020407@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1103100936130.30899@router.home>
References: <4D6CA843.3090103@cn.fujitsu.com> <4D787C30.1020407@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Lameter <cl@linux.com>

