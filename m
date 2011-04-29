Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab1D2MHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:07:25 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:43021 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777Ab1D2MHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:07:24 -0400
Message-ID: <4DBAA9B4.3070306@vmware.com>
Date: Fri, 29 Apr 2011 14:06:12 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
References: <201104212129.17013.arnd@arndb.de>	<20110428093039.GU17290@n2100.arm.linux.org.uk>	<1304024836.2513.198.camel@pasglop> <201104291326.25634.arnd@arndb.de>
In-Reply-To: <201104291326.25634.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 01:26 PM, Arnd Bergmann wrote:
> On Thursday 28 April 2011, Benjamin Herrenschmidt wrote:
>    
>>>> For PCI you can have the flag propagate from the PHB down, for busses
>>>> without a bus type (platform) then whoever instanciate them (the
>>>> platform code) can set that appropriately.
>>>>          
>>> How can you do that when it changes mid-bus heirarchy?  I'm thinking
>>> of the situation where the DRM stuff is on a child bus below the
>>> root bus, and the root bus has DMA coherent devices on it but the DRM
>>> stuff doesn't.
>>>        
>> But that's not PCI right ? IE. with PCI, coherency is a property of the
>> PHB...
>>      
> That is my understanding at least, but I'd like to have a confirmation
> from the DRM folks.
>
> I believe that the PC graphics cards that have noncoherent DMA mappings
> are all of the unified memory (integrated into the northbridge) kind,
> so they are not on the same host bridge as all regular PCI devices,
> even if they appear as a PCI device.
>    

I think Jerome has mentioned at one point that the Radeon graphics cards 
support
non-coherent mappings.

Fwiw, the PowerVR SGX MMU also supports this mode of operation, although 
it being functional I guess depends on the system implementation.

/Thomas



> 	Arnd
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>    

