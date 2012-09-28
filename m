Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2I1IjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:39:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:56493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2I1IjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:39:15 -0400
Message-ID: <1348821539.3292.49.camel@twins>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Date: Fri, 28 Sep 2012 10:38:59 +0200
In-Reply-To: <506537C7.9070909@linux.vnet.ibm.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	 <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com>
	 <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com>
	 <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com>
	 <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com>
	 <50643745.6010202@linux.vnet.ibm.com> <506440AF.9080202@redhat.com>
	 <506537C7.9070909@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 11:08 +0530, Raghavendra K T wrote:
> 
> Peter, Can I post your patch with your from/sob.. in V2?
> Please let me know.. 

Yeah I guess ;-)
