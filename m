Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab1I3KIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 06:08:44 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:63121 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1I3KIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 06:08:43 -0400
X-Authority-Analysis: v=2.0 cv=O6u7TWBW c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=Qu4DggT1IRAA:10 a=MMKwxLcYKssA:10 a=8nJEP1OIZ-IA:10 a=BlNDdlervjj4pFyOp5IA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <4E859529.2020504@cfl.rr.com>
Date: Fri, 30 Sep 2011 06:08:41 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: markh@compro.net, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with AMD chipsets. Was "Re: problems doing direct dma
 from a pci device to pci-e device"
References: <4E84CA01.2060907@compro.net> <4E84D55A.5050406@compro.net> <4E858200.8070302@ladisch.de>
In-Reply-To: <4E858200.8070302@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 04:46 AM, Clemens Ladisch wrote:
> Mark Hounschell wrote:
>> We have no problem with this same configuration using a MB with an
>> nvidia chipset. I suspect it might have something to do with the the MB
>> that usines the AMD chipset having an IOMMU, but I really don't know for
>> sure. I've also read something in the AMD chipset docs about some type
>> of restrictions on peer to peer transfers but again I really have no
>> idea if this is related to why I'm having this problem.
>
> According to the published RS780 docs, "P2P traffic could be only memory
> writes" (RPR 2.7).  In any case, check the P2P bits (MISC is described
> in BDG 2.4).
>
>

I wonder what they expect you to get out of "P2P traffic _could_ be only 
memory writes" Does that mean it _can_ be configured as "P2P traffic is 
enabled for only writes"? In any case I can do neither reads or writes.

As for the MISC bits described in the BDG, it appears that by default all 
the P2PDIS bits will be set to 0. Are there tools that would enable me to 
look at these bits and even change them if they are set. Would these bits 
normally be set/reset by the BIOS or the OS?

I previously asked about this problem on the AMD developers forum but got 
no response.

Thanks
Mark
