Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1JMQMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:12:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47600 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1JMQMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:12:43 -0400
MIME-Version: 1.0
In-Reply-To: <4E970B40.8070808@genband.com>
References: <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>
	<CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>
	<4E970B40.8070808@genband.com>
Date: Thu, 13 Oct 2011 18:12:42 +0200
Message-ID: <CA+O4pCJyTyhec54RYqdzmpR-Y2dSvgB6srv=bsF4DFsx3n33Yw@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 6:01 PM, Chris Friesen
<chris.friesen@genband.com> wrote:
> On 10/13/2011 09:19 AM, Markus Rechberger wrote:
>>
>> On Thu, Oct 13, 2011 at 4:58 PM, Alan Stern<stern@rowland.harvard.edu>
>>  wrote:
>
>>> This is very interesting.  There are only two things that could be
>>> happening: Either the device sends different data during the two tests,
>>> or there's a bug in the kernel.
>
>> Before that I insist that this patch will go into the kernel (I know
>> that sounds ridiculous but so far I did everything
>> you requested me to do), I clearly pointed out that we even have hardware
>> specs which can influence the transfer buffer. The patch does not hurt
>> and makes the device work.
>
> That makes no sense.  If there's a bug in the hardware we likely don't want
> to make global changes to work around it--a more targeted fix may be more
> appropriate.
>

Did you read the part about that we have some hardware which can do
some settings
in hardware to affect the transfer buffer? Even that part is not clear
how it can affect the
transfer for the usb subsystem.

Why on earth should things be done differently than with all other
operating systems?

> If there is a bug in the kernel, why would we want a bandaid patch that just
> happens to make it work rather than a true fix?
>

In silicon? Are you going to tape out another one for it?
First priority is that the device can work and be sold, my last
priority is that requested academic research (as we are not
the design house for the particular IC), I'm willing
to support it if my request is fulfilled, the demo videos are online
and show that it works with increasing the maximum allowed buffersize.

And about the particular device the boundaries are just around 7000
bytes off and people are screaming about that? Sorry this is just like
in kindergarden here.

Markus
