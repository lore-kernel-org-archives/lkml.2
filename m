Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2HAJmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:42:21 -0400
Received: from mail.profihost.ag ([85.158.179.208]:54821 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2HAJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:42:20 -0400
Message-ID: <5018F9F6.70307@profihost.ag>
Date: Wed, 01 Aug 2012 11:42:14 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag> <5017F19E.4070308@redhat.com> <501817C9.6090405@profihost.ag> <5018EC7D.9090702@redhat.com> <5018F5BB.9070500@profihost.ag> <5018F7E6.4020909@redhat.com>
In-Reply-To: <5018F7E6.4020909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.08.2012 11:33, schrieb Avi Kivity:
>> So here are 3 backtraces from booting the rescue system:
>> http://pastebin.com/raw.php?i=xCy2pEcP
>>
>> To me they all look the same.
>
> They are.  What version of qemu are you using?

latest stable-1.1 branch (1.1.1) - which works fine with latest RHEL6 
kernel.

Stefan
