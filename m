Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab1CDW7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:59:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab1CDW7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:59:38 -0500
Message-ID: <4D716ED7.5000200@redhat.com>
Date: Fri, 04 Mar 2011 17:59:35 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com> <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com> <20110304182733.GA2867@nik-comp.lan> <1299265762.11618.140.camel@mothafucka.localdomain> <20110304205512.GB2867@nik-comp.lan> <1299274906.11618.157.camel@mothafucka.localdomain> <20110304223640.GC2867@nik-comp.lan>
In-Reply-To: <20110304223640.GC2867@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 05:36 PM, Nikola Ciprich wrote:
>> I think although the long term plan is to just do this update once in
>> your case (stable tsc), this update is needed.
>>
>> Why don't you send a patch to re-include it ?
>>
>>      
> Yes, I'll gladly submit patch, one question, is this OK
> to just add calling kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu) before
> the conditional (as I did in my test), or should it go somewhere to else {..}
> section? it's called inside the conditional again, which will cause it
> to be called twice in some cases, is it OK?
> n.
>    

Let me write a patch to fix this..
