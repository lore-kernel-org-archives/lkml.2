Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1CFOxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:53:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1CFOxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:53:40 -0500
Message-ID: <4D739FEF.7000502@redhat.com>
Date: Sun, 06 Mar 2011 09:53:35 -0500
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
References: <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com> <20110304182733.GA2867@nik-comp.lan> <1299265762.11618.140.camel@mothafucka.localdomain> <20110304205512.GB2867@nik-comp.lan> <1299274906.11618.157.camel@mothafucka.localdomain> <20110304223640.GC2867@nik-comp.lan> <4D718F2D.6080105@redhat.com> <20110305072115.GA2166@nik-comp.lan>
In-Reply-To: <20110305072115.GA2166@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 02:21 AM, Nikola Ciprich wrote:
>    
>> Can you try this patch to see if it fixes the problem?
>>      
> You haven't read my replies, did you? ;-)
> kvm_request_guest_time_update seems to have been
> removed, and kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu)
> seems to be used instead, adding it fixes the problem.
> That's what I was going to use in the patch... :)
>    

I did read your mail, but I was working on an old tree... because of 
that transformation, this fix will unfortunately have to be back and 
forward ported by hand.

Did you try just that change right applied on top of the patch 
(e48672fa25e879f7ae21785c7efd187738139593) implicated by bisect?

It will be great to know if that change alone fixes the problem, if so, 
the fix you propose is probably the right one for upstream.

Thanks,

Zach
