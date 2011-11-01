Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1KAOux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:50:53 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:59258 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab1KAOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:50:52 -0400
Message-ID: <4EB006B8.8080001@vmware.com>
Date: Tue, 01 Nov 2011 15:48:24 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Thomas Hellstrom <thomas@shipmail.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, j.glisse@redhat.com,
        airlied@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH 06/11] ttm/driver: Expand ttm_backend_func to include
 two overrides for TTM page pool.
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com> <1319062772-2793-7-git-send-email-konrad.wilk@oracle.com> <4EA28FA6.7000006@shipmail.org> <20111101143715.GA8631@homer.localdomain>
In-Reply-To: <20111101143715.GA8631@homer.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 03:37 PM, Jerome Glisse wrote:
> On Sat, Oct 22, 2011 at 11:40:54AM +0200, Thomas Hellstrom wrote:
>    
>> Konrad,
>>
>> I was hoping that we could get rid of the dma_address shuffling into
>> core TTM,
>> like I mentioned in the review. From what I can tell it's now only
>> used in the backend and
>> core ttm doesn't care about it.
>>
>> Is there a particular reason we're still passing it around?
>>
>> Thanks,
>> /Thomas
>>
>>      
> I am working on patchset on top of this that will move dma handling
> back to driver and mostly out of ttm (the page alloc helper will
> still do dma stuff on behalf of driver) So if my patchset is acceptable
> the dma situation is transionary.
>
> Cheers,
> Jerome
>    
Cool.

Thanks, Jerome.

/Thomas

