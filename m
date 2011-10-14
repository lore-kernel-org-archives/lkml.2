Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1JNDmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 23:42:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54861 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab1JNDmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 23:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <CA+O4pCK2=rjqufLetTd=419bDfkN6RRX89Sh5noDnjoBAgoR2A@mail.gmail.com>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
	<CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
	<20111012203337.GA14572@suse.de>
	<CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com>
	<CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<CAAMvbhFNTQeuJBgsDB9Y5ODc_b2O0X=oP_3uwRpWUREFS9qufA@mail.gmail.com>
	<CA+O4pCK2=rjqufLetTd=419bDfkN6RRX89Sh5noDnjoBAgoR2A@mail.gmail.com>
Date: Fri, 14 Oct 2011 05:42:44 +0200
Message-ID: <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 4:47 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Fri, Oct 14, 2011 at 12:19 AM, James Courtier-Dutton
> <james.dutton@gmail.com> wrote:
>> Why don't you try a bulk size of 12032 instead of 24064 and not try 12288 as
>> you appear to be doing in the logs. Post the logs for that.
>
> I tried that earlier already of course it fails. If I could pick a
> smaller transfer size I would be happy since
> the device would work with all 2.6.x kernels out of the box and I
> wouldn't have to waste my time with it.
> Unfortunately it requires the 24064 bytes.
> The more flexible device A which is mentioned here confirms that there
> can be some impact on the
> bulk transfer size.
> However to learn about this it's needed to look at the bottom line of
> USB on the physical layer.
>
> And I disagree with Alan Cox it's not about being a crappy device or
> not, it's more like about something
> that is not well understood here. Most people are familiar with
> Software only here and not with the physical
> USB bottom Layer, otherwise the fact that the devices can have an
> impact on this wouldn't be such a surprise.
>

however to not say that I'm unwilling to do that and that is the
reason for not accepting this patch
http://www.sundtek.de/support/notworking2.log

even if the value is exposed to sysfs, it still requires the static
value in the kernel. The current value
used in the patch is based on what is in the HW specs of device A
which has the flexible bulk transfer setting.
The inflexible device which uses 24064 bytes works with all other
Operating systems by using that value
and gives exactly the same results with other transfer sizes than that.

BR,
Markus
