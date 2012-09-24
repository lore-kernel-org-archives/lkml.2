Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2IXQGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:06:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:41661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2IXQGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:06:07 -0400
Message-ID: <1348502757.11847.91.camel@twins>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Mon, 24 Sep 2012 18:05:57 +0200
In-Reply-To: <50608323.9000603@redhat.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	   <20120921120019.27611.66093.sendpatchset@codeblue>
	   <50607BBE.8070507@redhat.com> <1348500861.11847.72.camel@twins>
	  <50607F9B.7090701@redhat.com> <1348501929.11847.81.camel@twins>
	 <50608323.9000603@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 17:58 +0200, Avi Kivity wrote:
> There is the TSC deadline timer mode of newer Intels.  Programming the
> timer is a simple wrmsr, and it will fire immediately if it already
> expired.  Unfortunately on AMDs it is not available, and on virtual
> hardware it will be slow (~1-2 usec). 

Its also still a LAPIC write -- disguised as an MSR though :/

Also, who gives a hoot about virtual crap ;-)
