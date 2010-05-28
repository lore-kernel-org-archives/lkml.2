Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab0E1Rjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:39:52 -0400
Received: from king.tilera.com ([72.1.168.226]:7155 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912Ab0E1RiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:38:00 -0400
Message-ID: <4BFFFF73.2040600@tilera.com>
Date: Fri, 28 May 2010 13:37:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: arch/tile
References: <alpine.LFD.2.00.1005261601530.2995@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005261601530.2995@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 17:37:59.0202 (UTC) FILETIME=[83B4C820:01CAFE8C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2010 10:05 AM, Thomas Gleixner wrote:
>> We have an outstanding enhancement request in our bug tracking system to
>> switch to using the Linux generic IRQs directly, and plan to implement
>> it prior to our next major release.  But we haven't done it yet, and
>> this code, though somewhat crufty, is reasonably stable.  I'm also not
>> the primary maintainer of this particular piece of code, so I'd rather
>> wait until that person frees up and have him do it, instead of trying to
>> hack it myself.
>>     
>   It should be rather straight forward and can be efficiently done
>   with the handle_simple_irq() handler AFAICS. So I'd prefer to see
>   that fixed befor the code gets merged.
>   

OK, we have made changes to integrate to the Linux PERCPU IRQ mechanism,
which most closely matches what our interrupt layer did.  You should see
it a bit later when I post the revised diffs.

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


