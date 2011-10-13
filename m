Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1JMQ0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:26:12 -0400
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:37979 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1JMQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:26:10 -0400
X-Greylist: delayed 1475 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Oct 2011 12:25:59 EDT
Message-ID: <4E971112.3060703@genband.com>
Date: Thu, 13 Oct 2011 10:25:54 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
References: <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>	<Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>	<CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>	<4E970B40.8070808@genband.com> <CA+O4pCJyTyhec54RYqdzmpR-Y2dSvgB6srv=bsF4DFsx3n33Yw@mail.gmail.com>
In-Reply-To: <CA+O4pCJyTyhec54RYqdzmpR-Y2dSvgB6srv=bsF4DFsx3n33Yw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2011 16:25:56.0061 (UTC) FILETIME=[C8B210D0:01CC89C4]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18448.000
X-TM-AS-Result: No--16.248700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 10:12 AM, Markus Rechberger wrote:
> On Thu, Oct 13, 2011 at 6:01 PM, Chris Friesen

> Why on earth should things be done differently than with all other
> operating systems?

Linux does a lot of things differently than other operating systems.  In 
many cases it's because the other OS's do things wrong.  One could just 
as easily turn the question around and ask why on earth would your 
hardware be different than all the other USB hardware?

>> If there is a bug in the kernel, why would we want a bandaid patch that just
>> happens to make it work rather than a true fix?
>
> In silicon? Are you going to tape out another one for it?

If there's a bug in the kernel, the true fix would be in the kernel.

> And about the particular device the boundaries are just around 7000
> bytes off and people are screaming about that? Sorry this is just like
> in kindergarden here.

Actually I think that you're the one throwing a tantrum and yelling that 
it needs to be done your way or else.  We generally don't change global 
constants because one hardware device doesn't work.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
