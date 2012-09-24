Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab2IXQWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab2IXQWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:22:06 -0400
Message-ID: <50608887.7050204@redhat.com>
Date: Mon, 24 Sep 2012 18:21:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
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
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue>     <20120921120019.27611.66093.sendpatchset@codeblue>     <50607BBE.8070507@redhat.com> <1348500861.11847.72.camel@twins>    <50607F9B.7090701@redhat.com> <1348501929.11847.81.camel@twins>   <50608323.9000603@redhat.com> <1348502757.11847.91.camel@twins>  <50608608.4000507@redhat.com> <1348503219.11847.98.camel@twins>
In-Reply-To: <1348503219.11847.98.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 06:13 PM, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 18:10 +0200, Avi Kivity wrote:
>> > Its also still a LAPIC write -- disguised as an MSR though :/
>> 
>> It's probably a whole lot faster though. 
> 
> I've been told its not, I haven't tried it.

I'll see if I can find a machine with it (don't see it on my Westmere,
it's probably on one of the Bridges.  Or maybe the other Peter knows.


-- 
error compiling committee.c: too many arguments to function
