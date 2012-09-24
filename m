Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2IXLeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:34:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:36665 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab2IXLeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:34:05 -0400
Message-ID: <1348486423.11847.45.camel@twins>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Mon, 24 Sep 2012 13:33:43 +0200
In-Reply-To: <20120921120000.27611.71321.sendpatchset@codeblue>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	 <20120921120000.27611.71321.sendpatchset@codeblue>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 17:30 +0530, Raghavendra K T wrote:
> +unsigned long rq_nr_running(void)
> +{
> +       return this_rq()->nr_running;
> +}
> +EXPORT_SYMBOL(rq_nr_running); 

Uhm,.. no, that's a horrible thing to export.
