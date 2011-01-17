Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab1AQOwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:52:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1AQOws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:52:48 -0500
Message-ID: <4D345790.9010701@redhat.com>
Date: Mon, 17 Jan 2011 09:52:00 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Robert Richter <robert.richter@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] oprofile: Add support for missing Intel core i7 models
References: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com>	<20110113235503.GY4739@erda.amd.com>	<20110114002435.GR25713@one.firstfloor.org>	<20110114022950.GC4739@erda.amd.com> <20110114234327.GS25713@one.firstfloor.org>
In-Reply-To: <20110114234327.GS25713@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 06:43 PM, Andi Kleen wrote:
>> Will it be the general way in the future not to add model detection
>> for new Intel cpus to kernel code and instead use arch_perfmon? Are
> 
> Yes, at least for features that do not need specific new kernel support.
> And it looks like most (all?) of the these features will be perf only.
> 
> The advantage of the scheme is that it avoids the major problems
> we had with updates in the past where userland and kernel had to be
> updated in lock-step.
> 
>> the user land patches for cpu detection already in the oprofile
>> repository? I assume oprofile 0.9.6 is not up-to-date and needs to be
>> patched.
> 
> It's in CVS.
> 
> -Andi
> 
> ------------------------------------------------------------------------------
> Protect Your Site and Customers from Malware Attacks
> Learn about various malware tactics and how to avoid them. Understand 
> malware threats, the impact they can have on your business, and how you 
> can protect your company and customers by using code signing.
> http://p.sf.net/sfu/oracle-sfdevnl
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list

There are also Fedora 13, Fedora 14 and Fedora rawhide rpms available with this cpuid detection support in them. The Fedora 13 and Fedora 14 versions have bodhi updates, available via "yum update --enablerepo=updates-testing oprofile". Please give feedback on them on the Fedora update pages:

https://admin.fedoraproject.org/updates/oprofile-0.9.6-10.fc13
https://admin.fedoraproject.org/updates/oprofile-0.9.6-10.fc14


-Will
