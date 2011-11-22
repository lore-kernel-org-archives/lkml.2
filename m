Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab1KVWcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:32:39 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:22415 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758725Ab1KVWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:32:38 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5UuL.uoVM1k.br0xkmHCMwm9.Lfk.Y9wyih9Tjqf2S24l8G
 GmbBKzWdnhiN73Zd5IVcPtRZzMP6PAPrS3vapzoNMsVvH0aycGN_P5EdwqeS
 InRGRm7K6uMIw3Gyv6.vBAejFbd1i5_TOOiyOhgCyChvTWYdx0Vs57aVLcmN
 zizipwHVsC8ZjaGvYzM4WxESnSGQfaL9Nx6gpBy6iY5UD3kgCNdADjHCsiB2
 mykKD1r30k1ocUt64_fzlLPTZV4j3bbekRHwJiu1MojNecUwbv7Rw5XhPxR0
 Yz9nXEU8FF10nMeeiFlOR9Ya.Kp5Rpn1cqsIpYC5cvhojyWNGCrubKRcczlL
 KSHejchrdFVE7bqnRkGVuP2kAt2VbI1CD50FQc2qB4Gjt
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 16:32:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Christian Kujau <lists@nerdbynature.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <1322000195.14573.13.camel@pasglop>
Message-ID: <alpine.DEB.2.00.1111221632230.30368@router.home>
References: <20111121131531.GA1679@x4.trippels.de>  <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121153621.GA1678@x4.trippels.de>  <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121161036.GA1679@x4.trippels.de>
  <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121173556.GA1673@x4.trippels.de>  <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121185215.GA1673@x4.trippels.de>
  <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>  <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>  <alpine.DEB.2.00.1111212105330.19606@router.home>  <1321948113.27077.24.camel@edumazet-laptop>  <alpine.DEB.2.01.1111220038060.8000@trent.utfs.org>
 <1322000195.14573.13.camel@pasglop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Benjamin Herrenschmidt wrote:

> Eric, Christoph, the generic version of this_cpu_cmpxchg() is not
> interrupt safe, so I suppose this patch should go in right ?

Correct.

