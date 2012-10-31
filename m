Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2JaGPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:15:22 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44950 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2JaGPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:15:20 -0400
Message-ID: <5090C0DD.4070505@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 11:40:37 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V2 RFC 3/3] kvm: Check system load and handle different
 commit cases accordingly
References: <20121029140621.15448.92083.sendpatchset@codeblue> <20121029140717.15448.83182.sendpatchset@codeblue> <1351533280.24721.46.camel@twins> <508F6C60.1050202@linux.vnet.ibm.com> <1351584858.4047.32.camel@twins>
In-Reply-To: <1351584858.4047.32.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12103106-9574-0000-0000-000005184005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 01:44 PM, Peter Zijlstra wrote:
> On Tue, 2012-10-30 at 11:27 +0530, Raghavendra K T wrote:
>> Okay, now IIUC, usage of *any* global measure is bad?
>
> Yep, people like to carve up their machines, esp. now that they're
> somewhat bigger than they used to be. This can result in very asymmetric
> loads, no global measure can ever deal with that.

Thanks for explaining the concerns. Very True and if load is very 
asymmetric due to power optimization etc constraints. This may affect.


