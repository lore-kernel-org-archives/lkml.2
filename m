Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1CVEtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 00:49:52 -0400
Received: from mx1.guavus.com ([204.232.241.167]:64733 "EHLO mx1.guavus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1CVEtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 00:49:51 -0400
From: Preeti Khurana <Preeti.Khurana@guavus.com>
To: Preeti Khurana <Preeti.Khurana@guavus.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: rcu_sched_state detected stall on CPU issue
Thread-Topic: rcu_sched_state detected stall on CPU issue
Thread-Index: AQHL5DjRyp5tGIVRmkGAvfFAk36UcJQwcGkAgAEcutCAB0OYMA==
Date: Tue, 22 Mar 2011 04:44:46 +0000
Message-ID: <9F0C2539CB50A743894F8FCEEB1D5692083439@mx1.guavus.com>
References: <20110316101820.GA17540@linux.vnet.ibm.com>
 <20110317085938.C938.A69D9226@jp.fujitsu.com>
 <20110317022506.GG2304@linux.vnet.ibm.com>
 <9F0C2539CB50A743894F8FCEEB1D56920818B0@mx1.guavus.com>
In-Reply-To: <9F0C2539CB50A743894F8FCEEB1D56920818B0@mx1.guavus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>     I will try patching with the commits & test the same, though patches don't
> cleanly fit because they are on top of the changes which are not there in
> 2.6.35  ( have come in 2.6.37), so it's a lttle challenge.
> Meanwhile, I  am trying out the changes specified in thread
> https://lkml.org/lkml/2011/1/6/131 because I think that also might issue.


	The patch at  https://lkml.org/lkml/2011/1/6/131 (commit 88f5acf88ae6a9778f6d25d0d5d7ec2d57764a97) has solved the issue.
