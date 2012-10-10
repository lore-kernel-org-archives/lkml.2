Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2JJSEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:04:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44376 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab2JJSEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:04:00 -0400
Message-ID: <5075B88B.1000703@gmail.com>
Date: Wed, 10 Oct 2012 12:03:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: habanero@linux.vnet.ibm.com, Avi Kivity <avi@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com> <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com> <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins> <506DA48C.8050200@redhat.com>  <20121009185108.GA2549@linux.vnet.ibm.com> <1349837987.5551.182.camel@oc6622382223.ibm.com> <5075B63C.5030603@linux.vnet.ibm.com>
In-Reply-To: <5075B63C.5030603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/12 11:54 AM, Raghavendra K T wrote:
> No, I did something like this
> perf kvm  --guestvmlinux ./vmlinux.guest top -g  -U -d 3. Yes that is a
> good idea.
>
> (I am getting some segfaults with perf top, I think it is already fixed
> but yet to see the patch that fixes)

What version of perf:  perf --version


