Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2KUTZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:25:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53927 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab2KUTZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:25:15 -0500
Message-ID: <50AD2A85.7030705@zytor.com>
Date: Wed, 21 Nov 2012 11:24:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH] x86, smpboot: allow manual hotplug of CPUs
References: <1353522136-14944-1-git-send-email-sasha.levin@oracle.com> <50AD1CB6.9030707@zytor.com> <50AD1EE7.6020304@oracle.com> <50AD1F88.1010006@zytor.com> <50AD2953.5070700@oracle.com>
In-Reply-To: <50AD2953.5070700@oracle.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 11:19 AM, Sasha Levin wrote:
>>
>> So, are there any mptables platforms which support hotplug?  If the
>> answer is "KVM" then the answer is that KVM needs to move to ACPI to get
>> the proper functionality; putting a hack in is really not okay.
> 
> There are no platforms which support actual hotplug, but you can still set
> existing processors as disabled in the table and without this patch there's
> no way enable them.
> 
> I'm not sure if it's a "hack" though - the presentation of hotpluggable cpus
> is the almost the same between mptable and acpi, and acpi provides a way to
> manually probe/release cpus as well. The only difference is that acpi also
> provides notifications about such events.
> 
> Actually, maybe acpi should start using probe/release as well... hmm...
> 

The bottom line is that I don't want the underlying implementation to
end up with a user-visible difference... therein lies madness and lots
of bugs.

	-hpa


