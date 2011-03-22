Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1CVGcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 02:32:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48321 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1CVGci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 02:32:38 -0400
Date: Mon, 21 Mar 2011 23:32:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Preeti Khurana <Preeti.Khurana@guavus.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched_state detected stall on CPU issue
Message-ID: <20110322063210.GH2322@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110316101820.GA17540@linux.vnet.ibm.com>
 <20110317085938.C938.A69D9226@jp.fujitsu.com>
 <20110317022506.GG2304@linux.vnet.ibm.com>
 <9F0C2539CB50A743894F8FCEEB1D56920818B0@mx1.guavus.com>
 <9F0C2539CB50A743894F8FCEEB1D5692083439@mx1.guavus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F0C2539CB50A743894F8FCEEB1D5692083439@mx1.guavus.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:44:46AM +0000, Preeti Khurana wrote:
> 
> 
> >     I will try patching with the commits & test the same, though patches don't
> > cleanly fit because they are on top of the changes which are not there in
> > 2.6.35  ( have come in 2.6.37), so it's a lttle challenge.
> > Meanwhile, I  am trying out the changes specified in thread
> > https://lkml.org/lkml/2011/1/6/131 because I think that also might issue.
> 
> 
> 	The patch at  https://lkml.org/lkml/2011/1/6/131 (commit 88f5acf88ae6a9778f6d25d0d5d7ec2d57764a97) has solved the issue.

Glad it worked for you!

							Thanx, Paul
