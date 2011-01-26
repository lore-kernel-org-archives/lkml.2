Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1AZO7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:59:40 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:57966 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1AZO7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:59:39 -0500
Message-ID: <4D4036CB.2090200@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 12:59:23 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] tpm: fix panic caused by "tpm: Autodetect itpm devices"
References: <1294370641-6791-1-git-send-email-olof@lixom.net> <AANLkTi=E1_Ur6GmwBRnjGRBpmSup4_1_k35ZKvBRcFtv@mail.gmail.com> <4D388271.50404@linux.vnet.ibm.com> <alpine.LRH.2.00.1101211002490.13919@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1101211002490.13919@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11012614-8936-0000-0000-00000037DEB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 09:11 PM, James Morris wrote:
> On Thu, 20 Jan 2011, Rajiv Andrade wrote:
>
>> On 01/20/2011 03:37 PM, Olof Johansson wrote:
>>> Are all TPM maintainers MIA? This is a trivial patch that fixes a
>>> panic, and it was a late-added regression in 2.6.37.
>>>
>> Not myself. I missed this one unfortunately in my work queue, sorry, will keep
>> alert to avoid this happening again.
>>
>> Acked-by: Rajiv Andrade<srajiv@linux.vnet.ibm.com>
> Rajiv,
>
> I've mentioned this at least once before: as maintainer of TPM, ideally,
> what you should be doing is collecting the TPM patches, testing them in
> your own tree, then pushing them to me with an indication of where they
> need to end up (e.g. bugfixes for current linus vs. next), preferably via
> git.
>
> This is a significant part of what distinguishes maintainership from
> simply developing or reviewing code.
>
>
> - James

Sorry for the delays, I'm setting up a git tree now. Thanks for the 
heads up.

Rajiv

