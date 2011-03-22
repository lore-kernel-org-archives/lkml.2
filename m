Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1CVJTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1CVJTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:19:38 -0400
Message-ID: <4D88696C.6060203@redhat.com>
Date: Tue, 22 Mar 2011 11:18:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: Use syscore_ops instead of sysdev class and
 sysdev
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103220031.22729.rjw@sisk.pl> <201103220037.06465.rjw@sisk.pl>
In-Reply-To: <201103220037.06465.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 01:37 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
>
> KVM uses a sysdev class and a sysdev for executing kvm_suspend()
> after interrupts have been turned off on the boot CPU (during system
> suspend) and for executing kvm_resume() before turning on interrupts
> on the boot CPU (during system resume).  However, since both of these
> functions ignore their arguments, the entire mechanism may be
> replaced with a struct syscore_ops object which is simpler.
>

Acked-by: Avi Kivity <avi@redhat.com>

-- 
error compiling committee.c: too many arguments to function

