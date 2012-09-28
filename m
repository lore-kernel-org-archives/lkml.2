Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2I1GIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:08:00 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53283 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2I1GHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:07:20 -0400
Message-ID: <50653DB0.5090405@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 11:33:28 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com> <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com> <50643745.6010202@linux.vnet.ibm.com> <506440AF.9080202@redhat.com> <506537C7.9070909@linux.vnet.ibm.com> <50653986.2000709@zytor.com>
In-Reply-To: <50653986.2000709@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092806-2000-0000-0000-00000946E019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 11:15 AM, H. Peter Anvin wrote:
> On 09/27/2012 10:38 PM, Raghavendra K T wrote:
>> +
>> +bool kvm_overcommitted()
>> +{
>
> This better not be C...

I think you meant I should have had like kvm_overcommitted(void) and 
(different function name perhaps)

or is it the body of function?


