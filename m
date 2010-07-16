Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0GPRUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0GPRUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:20:40 -0400
Message-ID: <4C4094E0.7000403@redhat.com>
Date: Fri, 16 Jul 2010 07:20:32 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KVM timekeeping fixes, V2
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <20100716131907.GJ23755@8bytes.org>
In-Reply-To: <20100716131907.GJ23755@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 03:19 AM, Joerg Roedel wrote:
> On Mon, Jul 12, 2010 at 04:25:20PM -1000, Zachary Amsden wrote:
>    
>> Discovered brammage in patches due to unresolved merge.
>> Also, had to move 09/18 past 08/18 to resolve compile issue.
>>      
> Have you tested this patchset with Nested SVM? We had TSC handling
> related bugs there in the past and should make sure to keep it working.
>    

I've been very careful to keep nested SVM safe, but I've not got a good 
test for that.  Is there any test suite for the nested case?

It took a lot of guessing to figure out why it works and why the code 
looks imbalanced, but I now understand the way it is now is logical and 
correct.
