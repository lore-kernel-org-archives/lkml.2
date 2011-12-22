Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1LVJTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1LVJTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:19:09 -0500
Message-ID: <4EF2F5FB.1030200@redhat.com>
Date: Thu, 22 Dec 2011 11:18:51 +0200
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Eric B Munson <emunson@mgebm.net>,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <20111208113422.GA27919@amit-x200.redhat.com> <4EE9E023.4000904@redhat.com> <20111219125217.GC3139@amit-x200.redhat.com> <4EEF3538.9060808@redhat.com> <20111219175921.GA4668@amit-x200.redhat.com>
In-Reply-To: <20111219175921.GA4668@amit-x200.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 07:59 PM, Amit Shah wrote:
> On (Mon) 19 Dec 2011 [14:59:36], Avi Kivity wrote:
>> On 12/19/2011 02:52 PM, Amit Shah wrote:
>
> (snip)
>
>>> S4 needs some treatment, though, as resume after s4 doesn't work with
>>> kvmclock enabled.  I didn't realise this series was only handling the
>>> soft lockup case.
>>>
>>
>> What's the issue there?
>
> Not sure yet; after resume, the VM freezes while bringing the 2nd vcpu
> up.  Maybe it's just sitting there spinning, maybe the delta needs
> adjusting.  Haven't poked at it yet.

Bug 694801 - Guest fail to resume from S4 if guest using kvmclock
