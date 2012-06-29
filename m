Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2F2AVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 20:21:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:63280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab2F2AVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 20:21:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171365742"
Message-ID: <4FECF489.4080008@intel.com>
Date: Fri, 29 Jun 2012 08:19:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Konrad Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9FDD.6030102@kernel.org> <4FEAA4AA.3000406@intel.com> <4FEAA7A1.9020307@kernel.org> <90bcc2c8-bcac-4620-b3c0-6b65f8d9174d@default> <4FEB5204.3090707@linux.vnet.ibm.com> <4FEBBB5C.5000505@intel.com> <4FEC7668.3000403@linux.vnet.ibm.com>
In-Reply-To: <4FEC7668.3000403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 11:21 PM, Seth Jennings wrote:

> On 06/27/2012 09:03 PM, Alex Shi wrote:
>> Peter Anvin is merging my TLB patch set into tip tree, x86/mm branch.
> 
> Great! I don't know the integration path of this tree.  Will
> these patches go into mainline in the next merge window from
> here?
> 


$git clone git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

and get the branch of x86/mm

> --
> Seth
> 


