Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0GWAMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:12:33 -0400
Received: from claw.goop.org ([74.207.240.146]:53216 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab0GWAMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:12:32 -0400
Message-ID: <4C48DE6F.2080703@goop.org>
Date: Thu, 22 Jul 2010 17:12:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH] x86: Do not try to disable hpet if it hasn't been initialized
 before
References: <4C48D2C2.20303@goop.org> <4C48D62E.50405@zytor.com>
In-Reply-To: <4C48D62E.50405@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 04:37 PM, H. Peter Anvin wrote:
> On 07/22/2010 04:22 PM, Jeremy Fitzhardinge wrote:
>> [ x86 folk: While this patch is just a generic x86 bugfix, it really
>> only affects
>>    the Xen pv-on-hvm patch series that I'm going to post shortly.  Do
>> you want to
>>    commit it separately via tip.git, or are you OK with me sending it
>> to Linus
>>    directly? - J ]
>>
>
> I think it would be best if we took it via tip:x86/urgent, if that is
> okay with you.

Sure.

Thanks,
    J
