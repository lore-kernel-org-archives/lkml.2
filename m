Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab1DFWp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:45:56 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36440 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab1DFWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:45:54 -0400
Message-ID: <4D9CED15.2010806@ahsoftware.de>
Date: Thu, 07 Apr 2011 00:45:41 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        Eric Cooper <ecc@cmu.edu>
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the
 basis of the memory size.
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <1302122121-3652-2-git-send-email-holler@ahsoftware.de> <alpine.LFD.2.00.1104061739100.28032@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1104061739100.28032@xanadu.home>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.04.2011 23:44, Nicolas Pitre wrote:
> On Wed, 6 Apr 2011, Alexander Holler wrote:
>
>> It is possible to differentiate a SheevaPlugs and DockStars on the basis
>> of the memory size.
>>
>> This makes it possible to unify both setup files.
>
> No no no !!!  This is an abomination!
>
> We are not going to reduce the amount of code under arch/arm/ with such
> fragile hacks.  This would create an even worse maintenance problem the
> day either of those devices is released with more RAM or whatever.

DockStars are already obsolet and vanilla Linux was never supported by 
the manufacturer (Seagate). And they never used the machine type in 
question.

So I don't think this in any way a fragile hack.

Anyway, it was just a suggestion.

Regards,

Alexander
