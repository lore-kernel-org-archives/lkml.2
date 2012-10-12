Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab2JLOLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762Ab2JLOLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:11:19 -0400
Message-ID: <50782517.1020408@redhat.com>
Date: Fri, 12 Oct 2012 16:11:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs: Use-scatter-gather-lists-for-large-bulk-transfers
References: <20121010203118.GA792@polaris.bitmath.org> <5076819C.9010504@redhat.com> <20121011213707.GA2187@polaris.bitmath.org> <20121011215310.GA24651@kroah.com>
In-Reply-To: <20121011215310.GA24651@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/11/2012 11:53 PM, Greg Kroah-Hartman wrote:
> On Thu, Oct 11, 2012 at 11:37:07PM +0200, Henrik Rydberg wrote:
>> Hi Hans,
>>
>>> Oh what fun (not). The best way to figure out what really is going
>>> on is to get some usb level traces. Note my first hunch is that whath
>>> you're seeing is a device firmware bug, as this patch together with
>>> a new libusb (which you seem to also have) will make bulk transfers
>>> run slightly faster, which might be just enough to overwhelm your
>>> device ...
>>
>> Or, the large bulk transfer actually never worked in the first place.

Large input transfers certainly do, as they were part of my tests, but
I must admit my test cases seem to not include large output transfers
(my bad).

Thanks for fixing this!

>> The list you gave me seemed boringly long, so I read the patch more
>> closely instead. The fix below is the result. Greg, will you please
>> take it through your tree?
>
> Henrik, Very nice fix, thanks for debugging this.
>
> Hans, any objection to me taking this?

No objections please take it, this patch is:

Acked-by: Hans de Goede <hdegoede@redhat.com>

And stating the obvious:

CC: stable@vger.kernel.org

To be backported to 3.6 only

Thanks & Regards,

Hans
