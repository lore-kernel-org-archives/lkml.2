Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab1ELSXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:23:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24627 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405Ab1ELSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:23:06 -0400
Message-ID: <4DCC257E.9060307@kernel.org>
Date: Thu, 12 May 2011 11:22:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource allocation.
References: <4DC250A6.9040802@kernel.org> <20110506081243.GF16782@ram-laptop> <4DC4586C.6020308@kernel.org> <20110507015240.GN16782@ram-laptop> <4DC4B059.3030502@kernel.org> <4DC64C58.70203@kernel.org> <20110509142014.617e3100@jbarnes-desktop> <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com> <4DC9E415.5010402@kernel.org> <20110512180638.GA5012@ram-laptop> <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
In-Reply-To: <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DCC2586.0054,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 11:14 AM, Linus Torvalds wrote:
> On Thu, May 12, 2011 at 11:06 AM, Ram Pai <linuxram@us.ibm.com> wrote:
>>
>> I like this approach than the earlier approach because it
>> closes the subtle bug _introduced_ by my earlier patch,
>>        commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
>>
>> However i think the implementation can be made cleaner. Comments below..
> 
> Ack on all of that. Do we have confirmation that the patch works, though?
> 

yes. that patch fixes the problem.

Thanks

Yinghai
