Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1BFRvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 12:51:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43720 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1BFRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 12:51:46 -0500
Message-ID: <4D4EDF39.9090307@kernel.org>
Date: Sun, 06 Feb 2011 09:49:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>	<4D4A3782.3050702@zytor.com>	<alpine.DEB.2.00.1102031114030.7277@kaball-desktop>	<4D4ADFAD.7060507@zytor.com>	<alpine.DEB.2.00.1102041130060.7277@kaball-desktop>	<4D4CA568.70907@goop.org> <AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com> <4D4E4E0D.2080806@zytor.com>
In-Reply-To: <4D4E4E0D.2080806@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D4EDF7B.0056,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 11:30 PM, H. Peter Anvin wrote:
> On 02/05/2011 11:02 PM, Yinghai Lu wrote:
>> why not just move calling cleanup_highmap down?
>>
>> something like attached patch.
> 
> This patch looks very clean and looks on the surface of it like it is
> removing some ugly ad hoc code, but (as always) it needs a description
> about the problem it solves and why it is correct.
> 

just cleanup on native platform.

but wonder if could cause problem for xen memory hotplug support.

Thanks

Yinghai
