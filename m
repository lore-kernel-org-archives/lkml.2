Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1KVOoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:44:18 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:48454 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756879Ab1KVOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:44:15 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: o8gJI_wVM1kZ5S2gtc2Ibafhfdo2c_9uGcyYuq4b73nTKFH
 5.TQQaAyiCAwN1sHxum84wFaioR0oLciQ6IE7w1YHKef7AVlKY.rf4AYMHmx
 y5qJqbAgs8IqOf9TJ5DJYpf77JxWgEpiE354IO.XIjY0c17Uz7PN5S5g8UBA
 PUpvfJMJt6QkJP8av47qwHC0.h9K9sbyyf_RVhj8qJv5IELhI0h0VQ1A9qPP
 aQN3Ih6WEkEkLcUW7SpSjKv411Wb2IKpmPWdzxmXQ.PSNCHdsEhqsj0xE9zh
 ucWoLWo6WADKHqtHrDYTFCJRfQI.WTM3qBXX5OaBmieS9R5vnBKEVVCQuyPj
 pqRHiCGWXVGt_GZ8J.1lB7muR_D_OaEvkHu37KyJg9hl.
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 08:44:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <1321954729.2474.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111220843420.25785@router.home>
References: <20111121161036.GA1679@x4.trippels.de>  <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121173556.GA1673@x4.trippels.de>  <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
  <20111121185215.GA1673@x4.trippels.de>  <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>  <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>  <alpine.DEB.2.00.1111212105330.19606@router.home>  <20111122084513.GA1688@x4.trippels.de>
 <1321954729.2474.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> Given slub is now lockless, validate_slab_slab() is probably very wrong
> these days.

Debugging reenables the use of the page lock.

