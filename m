Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab0GSILs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 04:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688Ab0GSILq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:11:46 -0400
Message-ID: <4C4408BF.1020207@redhat.com>
Date: Sun, 18 Jul 2010 22:11:43 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KVM timekeeping fixes, V2
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <4C431904.7050005@redhat.com>
In-Reply-To: <4C431904.7050005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 05:08 AM, Avi Kivity wrote:
> On 07/13/2010 05:25 AM, Zachary Amsden wrote:
>> Discovered brammage in patches due to unresolved merge.
>> Also, had to move 09/18 past 08/18 to resolve compile issue.
>
> Ok, so I made some comments out of habit, but they're all very minor 
> compared to the complexity of the subject.
>

It's okay, there will be a V3 coming now.
