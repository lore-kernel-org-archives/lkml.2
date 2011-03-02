Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab1CBWRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:17:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37060 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab1CBWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:17:51 -0500
Message-ID: <4D6EC20B.5090007@canonical.com>
Date: Wed, 02 Mar 2011 23:17:47 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.30
References: <20110302145828.GA4999@kroah.com> <4D6E7548.807@canonical.com> <20110302204202.GB19022@suse.de>
In-Reply-To: <20110302204202.GB19022@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 09:42 PM, Greg KH wrote:
> On Wed, Mar 02, 2011 at 05:50:16PM +0100, Stefan Bader wrote:
>>> FUJITA Tomonori (1):
>>>       swiotlb: fix wrong panic
>>>
>>
>> This one breaks compilation of 64bit for me as swiotlb_tbl_unmap_single() does
>> not exist. It does not look like it is a simple single patch that would get it
>> back to 2.6.32.
> 
> I don't understand.  Is this patch somehow broken?  Is there an
> additional patch I need to apply to fix the build issue?  I need more
> information here.
> 

This is a patch included in your 2.6.32.30 release and it is broken because it
uses a function that does not exist in 2.6.32. When I looked at the git blame of
the function in Linus tree it consists of multiple shas. So it would be more
than one single patch needed from there.

-Stefan

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

