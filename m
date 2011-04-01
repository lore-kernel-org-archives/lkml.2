Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab1DASls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:41:48 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:19735 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab1DASlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:41:47 -0400
X-IronPort-AV: E=Sophos;i="4.63,283,1299456000"; 
   d="scan'208";a="329149870"
Message-ID: <4D961C6A.9070808@cisco.com>
Date: Fri, 01 Apr 2011 11:41:46 -0700
From: Michael Sundius <msundius@cisco.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        David VomLehn <dvomlehn@cisco.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andy Whitcroft <apw@shadowen.org>, Jon Fraser <jfraser@broadcom.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH v2] MIPS: Kernel crashes on boot with SPARSEMEM + HIGHMEM
 enabled
References: <c300b67a7a723369872c0b9a023d0b2e@localhost> <4D9603D8.2010709@caviumnetworks.com>
In-Reply-To: <4D9603D8.2010709@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
>
>
> I think this may do the same thing as my patch:
>
> http://patchwork.linux-mips.org/patch/1988/
>
> Although my patch had different motivations, and changes some other 
> things around too.
>
> David Daney
>
I'm not really sure why your kernel or initrd would be in memory was not 
within
the range that had been accounted for.  are you saying its in high mem?



