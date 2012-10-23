Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2JWAga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:36:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38043 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab2JWAg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:36:29 -0400
Message-ID: <5085E663.6040307@zytor.com>
Date: Mon, 22 Oct 2012 17:35:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, x86@kernel.org, mingo@elte.hu,
        tglx@linutronix.de, len.brown@intel.com, fenghua.yu@intel.com,
        vgoyal@redhat.com, grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6> <20121016043528.20003.601.stgit@localhost6.localdomain6> <873916i88t.fsf@xmission.com> <5085A9A8.5020004@zytor.com> <87fw56fduo.fsf@xmission.com> <5085AD7D.106@zytor.com> <87a9vedyqe.fsf@xmission.com> <5085B0D0.9020508@zytor.com> <87mwze8abu.fsf@xmission.com>
In-Reply-To: <87mwze8abu.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 02:29 PM, Eric W. Biederman wrote:
>>
>> As I said, I thought Fenghua tried that but it didn't work, experimentally.
>
> Fair enough.  You described the problem with clearing bit 8 in a weird
> way.
>
> If the best we can muster are fuzzy memories it may be worth revisiting.
> Perhaps it works on enough cpu models to be interesting.
>

It isn't fuzzy memories... this was done as late as 1-2 months ago.  I 
just don't know the details.

Fenghua, could you help fill us in?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

