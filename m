Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1FVU0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:26:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34827 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab1FVU0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:26:10 -0400
Message-ID: <4E024FC5.6020707@zytor.com>
Date: Wed, 22 Jun 2011 13:25:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, mingo@elte.hu,
        rick@vanrein.org, rdunlap@xenotime.net, Nancy Yuen <yuenn@google.com>,
        Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110622110034.89ee399c.akpm@linux-foundation.org> <20110622182445.GG3263@one.firstfloor.org> <20110622113851.471f116f.akpm@linux-foundation.org> <20110622185645.GH3263@one.firstfloor.org> <4E023CE3.70100@zytor.com> <20110622191558.GI3263@one.firstfloor.org>
In-Reply-To: <20110622191558.GI3263@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 12:15 PM, Andi Kleen wrote:
> On Wed, Jun 22, 2011 at 12:05:07PM -0700, H. Peter Anvin wrote:
>> On 06/22/2011 11:56 AM, Andi Kleen wrote:
>>>
>>> You'll always have multiple ways. Whatever magic you come up for
>>> the google BIOS or for EFI won't help the majority of users with
>>> old crufty legacy BIOS.
>>>
>>
>> I don't think this has anything to do with this.
> 
> Please elaborate.
> 
> How would you pass the bad page information instead in a fully backwards
> compatible way?
> 

Depends on what you mean with "fully backward compatible".  In some ways
this is a nonsense statement since if we create anything new older
kernels will not run.

However, the other discussions in this thread have been about injecting
data in kernel-specific data structures and thus aren't dependent on the
firmware layer used.

The fully backward compatible way is "memmap=<address>$<length>".

	-hpa

