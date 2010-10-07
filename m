Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0JGScF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:32:05 -0400
Received: from claw.goop.org ([74.207.240.146]:34792 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0JGScE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:32:04 -0400
Message-ID: <4CAE121E.4080607@goop.org>
Date: Thu, 07 Oct 2010 11:31:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CACFDAD.3090900@goop.org> <4CACFECD.3090304@kernel.org> <4CACFF66.5080609@zytor.com>
In-Reply-To: <4CACFF66.5080609@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/06/2010 03:59 PM, H. Peter Anvin wrote:
> On 10/06/2010 03:57 PM, Yinghai Lu wrote:
>> How about
>> +	if (memblock.memory.regions)
>> +		return;	
>>
> I was just about to ask the same question. ;)

I don't mind either way.  I haven't really looked at how memblock works,
so I wasn't sure if that was completely sufficient.

    J
