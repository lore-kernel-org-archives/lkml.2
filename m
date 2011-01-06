Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1AFLkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:40:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab1AFLkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:40:18 -0500
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4D25A710.5030500@redhat.com>
Date: Thu, 6 Jan 2011 12:40:16 +0100
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C35A7DC7-EBFD-464F-975E-F89886D299A8@suse.de>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-3-git-send-email-zamsden@redhat.com> <F57C0733-9A1A-4A6D-9D62-39B836559878@suse.de> <4D25A710.5030500@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.01.2011, at 12:27, Zachary Amsden wrote:

> On 01/06/2011 12:34 AM, Alexander Graf wrote:
>> Am 06.01.2011 um 11:10 schrieb Zachary Amsden<zamsden@redhat.com>:
>> 
>>   
>>> Use an MSR to allow "soft" migration to hosts which do not support
>>> TSC trapping.  Rather than make this a required element of any
>>> migration protocol, we allow the TSC rate to be exported as a data
>>> field (useful in its own right), but we also allow a one time write
>>> of the MSR during VM creation.  The result is that for the common
>>> use case, no protocol change is required to communicate TSC rate
>>> to the receiving host.
>>> 
>>> This allows administrative tools to configure migration policy
>>> as they see appropriate.  Rather than dictate this policy with the
>>> KVM implementation, we properly allow migration to hosts which both
>>> do and do not support setting of the TSC rate on the receiving end.
>>> If it is wished to not support migration to a host which lacks
>>> support for the TSC rate feature, that can be coordinated externally.
>>>     
>> Isn't there a real hw equivalent of such a register? It might make more sense to just implement that then.
>> 
>>   
> 
> Unfortunately, no.

Bleks. I couldn't find anything in AMD documentation either. Intel documentation is usually hard to find and incomplete anyways, so maybe something's hiding there - but if it's hidden so well it's no use to implement either.


Alex

