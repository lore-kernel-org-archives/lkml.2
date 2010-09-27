Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0I0XdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:33:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64186 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0I0XdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:33:04 -0400
Message-ID: <4CA12976.5060504@kernel.org>
Date: Mon, 27 Sep 2010 16:32:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: caiqian@redhat.com, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org> <4CA11FB7.2080101@zytor.com> <4CA126BE.7000609@kernel.org> <4CA1283C.9010105@zytor.com>
In-Reply-To: <4CA1283C.9010105@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 04:26 PM, H. Peter Anvin wrote:
> On 09/27/2010 04:20 PM, Yinghai Lu wrote:
>>
>> x86 own version for find_area?
>>
> 
> No, double no.
> 
> Same kind of crap: overloading an interface with semantics it shouldn't
> have.  The right thing is to introduce a new interface with carries the
> explicitly needed policy with it... e.g. memblock_find_in_range_lowest().
> 
> That interface would have the explicit semantics of returning the lowest
> possible address, as opposed to any suitable address (which may change
> if policy requirements change.)
> 
> The other question is why does kexec need this in the first place?  Is
> this due to a design bug in kexec or is there some fundamental reason
> for this?

bzImage is used here. so need range below 4g.

Yinghai
