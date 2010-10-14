Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0JNKmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:42:16 -0400
Received: from canuck.infradead.org ([134.117.69.58]:53182 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0JNKmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:42:15 -0400
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed
 their local quota
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <AANLkTikFRLXrdY6_qV5PHeSgH1Dd24ApaHs8R-ixOed=@mail.gmail.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075202.GD9893@in.ibm.com>
	 <20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com>
	 <1287047542.29097.169.camel@twins>
	 <20101014185002.6ecb2bf5.kamezawa.hiroyu@jp.fujitsu.com>
	 <1287050395.29097.176.camel@twins>
	 <20101014190828.f835c5e2.kamezawa.hiroyu@jp.fujitsu.com>
	 <AANLkTikFRLXrdY6_qV5PHeSgH1Dd24ApaHs8R-ixOed=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 12:41:44 +0200
Message-ID: <1287052904.29097.191.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 03:25 -0700, Paul Turner wrote:
> > "When vcpu holds spinlock in kernel, please don't sleep.." will be nice.
> > Is there patch already ? 

Oh you're talking about the guest spinlock crap? I don't particularly
care about that.. that's a virt problem you see ;-)
