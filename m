Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0IPPu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:50:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:41832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0IPPu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:50:59 -0400
Subject: Re: 2.6.35-stable/ppc64/p7: suspicious rcu_dereference_check()
 usage detected during 2.6.35-stable boot
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: paulmck@linux.vnet.ibm.com, Subrata Modak <subrata@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        sachinp <sachinp@linux.vnet.ibm.com>,
        DIVYA PRAKASH <dipraksh@linux.vnet.ibm.com>
In-Reply-To: <10430.1284649951@localhost>
References: <1280739132.15317.9.camel@subratamodak.linux.ibm.com>
	 <20100809161200.GC3026@linux.vnet.ibm.com>  <10430.1284649951@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Sep 2010 17:50:48 +0200
Message-ID: <1284652248.2275.570.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 11:12 -0400, Valdis.Kletnieks@vt.edu wrote:
> 
> Ping?  I just hit it on 2.6.36-rc4-mmotm0915.  Just wanted to make sure the
> issue hadn't been lost/forgotten. 

lost,.. thanks!
