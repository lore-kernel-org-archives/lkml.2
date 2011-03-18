Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1CRI1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:27:46 -0400
Received: from smtp.nokia.com ([147.243.1.48]:62563 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab1CRI1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:27:42 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" 
	<remi.denis-courmont@nokia.com>
Organization: MeeGo Devices - Nokia
To: ext Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 28/36] net,rcu: convert call_rcu(phonet_device_rcu_free) to kfree_rcu()
Date: Fri, 18 Mar 2011 10:27:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.9; KDE/4.5.1; i686; ; )
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4D82DADF.4010802@cn.fujitsu.com>
In-Reply-To: <4D82DADF.4010802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103181027.25735.remi.denis-courmont@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011 06:09:03 ext Lai Jiangshan, you wrote:
> The rcu callback phonet_device_rcu_free() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(phonet_device_rcu_free).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

In principles, that's fine with me. But I think David is not taking that kind 
of not-a-fix patch at the moment...

-- 
Rémi Denis-Courmont
http://www.remlab.net/
