Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab0GAVus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:50:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59811 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab0GAVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:50:28 -0400
Message-ID: <4C2D0D2D.8090407@oracle.com>
Date: Thu, 01 Jul 2010 14:48:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Zach Pfeffer <zpfeffer@codeaurora.org>, mel@csn.ul.ie, andi@firstfloor.org,
       dwalker@codeaurora.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <alpine.DEB.2.00.1007011450130.13691@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1007011450130.13691@utopia.booyaka.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C2D0D78.0207:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/10 13:59, Paul Walmsley wrote:
> Randy,
> 
> On Thu, 1 Jul 2010, Randy Dunlap wrote:
> 
>>> + * @start_addr	The starting address of the VCM region.
>>> + * @len 	The len of the VCM region. This must be at least
>>> + *		vcm_min() bytes.
>>
>> and missing lots of struct members here.
>> If some of them are private, you can use:
>>
>> 	/* private: */
>> ...
>> 	/* public: */
>> comments in the struct below and then don't add the private ones to the
>> kernel-doc notation above.
> 
> To avoid wasting space in structures, it makes sense to place fields 
> smaller than the alignment width together in the structure definition.  
> If one were to do this and follow your proposal, some structures may need 
> multiple "private" and "public" comments, which seems undesirable.  The 
> alternative, wasting memory, also seems undesirable.  Perhaps you might 
> have a proposal for a way to resolve this?

I don't know of a really good way.  There are a few structs that have
multiple private/public entries, and that is OK.
Or you can describe all of the entries with kernel-doc notation.
Or you can choose not to use kernel-doc notation on some structs.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
