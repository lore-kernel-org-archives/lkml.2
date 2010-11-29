Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0K2Rrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:47:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab0K2Rrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:47:42 -0500
Message-ID: <4CF3E733.8090809@redhat.com>
Date: Mon, 29 Nov 2010 07:47:31 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 22 (kvm)
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>	<20101122132627.bd4e88ef.randy.dunlap@oracle.com> <20101129083324.6870d7da.randy.dunlap@oracle.com> <4CF3D637.6060204@redhat.com>
In-Reply-To: <4CF3D637.6060204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 06:35 AM, Avi Kivity wrote:
> On 11/29/2010 06:33 PM, Randy Dunlap wrote:
>> On Mon, 22 Nov 2010 13:26:27 -0800 Randy Dunlap wrote:
>>
>> >  On Mon, 22 Nov 2010 13:49:11 +1100 Stephen Rothwell wrote:
>> >
>> > >  Hi all,
>> > >
>> > >  Changes since 20101119:
>> >
>> >
>> >  kvm.c:(.init.text+0x11f49): undefined reference to 
>> `kvm_register_clock'
>> >
>> >  when CONFIG_KVM_CLOCK is not enabled.
>>
>>
>> BUild error still present in linux-next-2010-NOV-29.
>>
>
> Glauber, Zach?
>

I can only speculate this reference is being called from smpboot without 
CONFIG guarding?
