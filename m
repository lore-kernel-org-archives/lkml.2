Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab1LNPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:01:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab1LNPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:01:30 -0500
Message-ID: <4EE8BA37.5070607@redhat.com>
Date: Wed, 14 Dec 2011 17:01:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Eric B Munson <emunson@mgebm.net>,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        ryanh@linux.vnet.ibm.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>	<4EDF7B0D.4060001@redhat.com> <20111214121622.GB18317@amt.cnet> <4EE8B53C.6070502@redhat.com> <4EE8B78F.9090104@us.ibm.com>
In-Reply-To: <4EE8B78F.9090104@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 04:49 PM, Anthony Liguori wrote:
>>
>>> About SIGSTOP, that is a corner case. Unsure if its even properly
>>> supported
>>> by QEMU.
>>
>> It works from my experience.
>
>
> We don't adjust vm_clock's offset on SIGSTOP/SIGCONT so while it may
> appear to work okay, QEMU isn't exhibiting the behavior it is supposed
> to.

Should we trap and handle SIGCONT?

-- 
error compiling committee.c: too many arguments to function

