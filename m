Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab0IGVZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:25:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:28209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab0IGVZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:25:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,330,1280732400"; 
   d="scan'208";a="321909641"
Message-ID: <4C86ADB9.8030401@linux.intel.com>
Date: Tue, 07 Sep 2010 14:25:13 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH 0/2] initramfs: Cleanup and fix initramfs size calculation
References: <20100831082307.064687027@linux.vnet.ibm.com> <4C7D0CDB.6030903@suse.cz>
In-Reply-To: <4C7D0CDB.6030903@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 07:08 AM, Michal Marek wrote:
> On 31.8.2010 10:23, Hendrik Brueckner wrote:
>> Hello Michal, Sam,
>>
>> I did not see any further comments on the patch series about the
>> initramfs cleanup and new size calculation.
> 
> Sorry about that, I don't always have as much time for kbuild as I would
> like to have :(.
> 
> 
>> This is a resend and now I am asking you for your review and ack.
>> Please let me know if you have questions or comments.
> 
> I like the cleanup patch and the thing still survives (very basic)
> testing, so
> Acked-by: Michal Marek <mmarek@suse.cz>
> 
> I'm wondering which tree should these patches go through... Peter, will
> you apply them to some branch of tip.git or should I apply them to
> kbuild-2.6.git?
> 

[Sorry for late reply, I have been away]

It's up to you, but I'm happy to apply them to a tip branch with your ack.

	-hpa
