Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2KSGPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:15:00 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45694 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2KSGO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:14:59 -0500
Message-ID: <50A9CE6A.3080208@linux.vnet.ibm.com>
Date: Mon, 19 Nov 2012 11:45:06 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: michael.neuling@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc, perf: Change PMU flag values representation
 from decimal to hex
References: <1353056344-1392-1-git-send-email-khandual@linux.vnet.ibm.com> <20121116114219.GA5745@bloggs.ozlabs.ibm.com>
In-Reply-To: <20121116114219.GA5745@bloggs.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12111906-1396-0000-0000-0000022EB22C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 05:12 PM, Paul Mackerras wrote:
> On Fri, Nov 16, 2012 at 02:29:04PM +0530, Anshuman Khandual wrote:
>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> 
> That's not a sufficient description of why you are making this
> change.  In particular, what is the motivation for and impact of using
> LONG_ASM_CONST?
> 
> Paul.

Hey Paul,

I have just sent out a revised patch where I have updated the description
and dropped the usage of LONG_ASM_CONST.

Regards
Anshuman 
 

