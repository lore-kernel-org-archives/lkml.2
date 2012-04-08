Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2DHQV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 12:21:29 -0400
Received: from mail2.charite.de ([141.42.206.200]:33585 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab2DHQV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 12:21:28 -0400
Date: Sun, 8 Apr 2012 18:21:24 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.3.0: "INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)"
Message-ID: <20120408162124.GA30947@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20120327141536.GP25457@charite.de>
 <20120328112822.GH16671@charite.de>
 <20120406175210.GA2421@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120406175210.GA2421@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney <paulmck@linux.vnet.ibm.com>:

> This stack looks interesting -- might be a problem in vmalloc_sync(),
> at least if the stack can be trusted.  Could you please reproduce with
> frame pointers enabled?

I'll rebuild the kernel right away, Sir.

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
