Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967002Ab2EOVYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:24:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:60276 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966928Ab2EOVY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:24:27 -0400
Message-ID: <1337117047.27694.119.camel@twins>
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets
 during suspend/resume
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 15 May 2012 23:24:07 +0200
In-Reply-To: <4FB2C8EA.6020800@linux.vnet.ibm.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
	 <20120513231710.3566.45349.stgit@srivatsabhat>
	 <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com>
	 <20120515014042.GA9774@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
	 <20120515044539.GA25256@linux.vnet.ibm.com>
	 <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com>
	 <1337112653.27694.110.camel@twins>
	 <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com>
	 <1337116107.27694.114.camel@twins> <4FB2C8EA.6020800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 02:51 +0530, Srivatsa S. Bhat wrote:

> And which I did :-) (well, essentially that's what this patchset (v3) did.)
> 
Oh right.. :-) I'll try and have a look tomorrow.
