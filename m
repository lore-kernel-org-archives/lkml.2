Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934914Ab1IOUsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:48:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:57792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934721Ab1IOUsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48883165"
Message-ID: <4E726489.6080606@linux.intel.com>
Date: Thu, 15 Sep 2011 13:48:09 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>	<1316117394-21666-8-git-send-email-andi@firstfloor.org> <CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com>
In-Reply-To: <CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2011 1:45 PM, Josh Boyer wrote:
> On Thu, Sep 15, 2011 at 4:09 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>> From: Andi Kleen<ak@linux.intel.com>
>>
> What's the problem again?

It's wrong. For more details see 0/*

>       "amcc,kilauea",
> There's an almost identical section in
> arch/powerpc/platforms/44x/ppc44x_simple.c.  Does that need whatever
> this is fixing as well?

That one is not const.

-Andi


