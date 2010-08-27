Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab0H0L71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:59:27 -0400
Received: from p-mail1.rd.francetelecom.com ([195.101.245.15]:30330 "EHLO
	p-mail1.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab0H0L7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:59:24 -0400
Message-ID: <4C77A89A.3070906@Free.fr>
Date: Fri, 27 Aug 2010 13:59:22 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Lightning/1.0b2 Icedove/3.1.2
MIME-Version: 1.0
To: Phil Turmel <philip@turmel.org>
CC: linux-kernel@vger.kernel.org, Florian Mickler <florian@mickler.org>
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
References: <4C728790.7050805@Free.fr> <4C72EE8F.3040708@turmel.org> <4C768919.30104@Free.fr> <4C76C641.30901@turmel.org>
In-Reply-To: <4C76C641.30901@turmel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2010 11:59:22.0575 (UTC) FILETIME=[49A4C5F0:01CB45DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 09:53 PM, Phil Turmel wrote:

>
>> Now I'm really puzzled grub2 as a "search by fs uuid" command that linux is unable to deliver for the root device!
>
> The key word here is "unable".  The maintainers aren't *unable* to do this.  They are *unwilling* to do this.  I don't recall the precise discussion, but basically it boils down to the fact that early userspace (aka initramfs) can do this efficiently, and it needs to be supported in initramfs for other reasons, so it is pointless to duplicate this code in the kernel.  I'm sure block folk will chime in if this isn't a fair representation (my apologies in advance if so).
>
> Try dracut.  Seriously.  It's lean and mean just for this use-case, and you'll be protecting yourself against future changes in the block layer.  And you can put root=LABEL=foo on your kernel command line to match your fstab.


This is a rather bizarre argument as because of this situation
	1) the code is duplicated between the initramfs and the real disk
	2) the initramfs has to be rebuild each time a new kernel is done
	3) The tmpdevfs is also a dupplicate somehow

Never mind.

-- eric
