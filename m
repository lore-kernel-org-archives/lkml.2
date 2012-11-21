Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2KUSiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:38:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53534 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab2KUSiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:38:14 -0500
Message-ID: <50AD1F88.1010006@zytor.com>
Date: Wed, 21 Nov 2012 10:38:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH] x86, smpboot: allow manual hotplug of CPUs
References: <1353522136-14944-1-git-send-email-sasha.levin@oracle.com> <50AD1CB6.9030707@zytor.com> <50AD1EE7.6020304@oracle.com>
In-Reply-To: <50AD1EE7.6020304@oracle.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 10:35 AM, Sasha Levin wrote:
>>
>> Reading between the lines, this sounds like would cause a user-visible
>> difference between mptable platforms and ACPI platforms?  If so, that is
>> totally unacceptable.  If not, the description is confusing.
> 
> With ACPI platforms you don't need probe/release because the hardware notifies
> on CPU insert/eject - this doesn't exist on mptable which is why you have to
> do it manually with probe/release.
> 
> The difference is already user visible: you can hotplug on ACPI, but can't on
> mptables.
> 
> Yes, reading back the subject does sound confusing - a better one would probably
> be "provide interface for CPU hotplug on mptable platforms" or something similar.
> 

So, are there any mptables platforms which support hotplug?  If the
answer is "KVM" then the answer is that KVM needs to move to ACPI to get
the proper functionality; putting a hack in is really not okay.

	-hpa


