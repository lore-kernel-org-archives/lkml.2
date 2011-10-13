Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1JMQBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:01:37 -0400
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:45366 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1JMQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:01:36 -0400
Message-ID: <4E970B40.8070808@genband.com>
Date: Thu, 13 Oct 2011 10:01:04 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
References: <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>	<Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org> <CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>
In-Reply-To: <CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2011 16:01:06.0645 (UTC) FILETIME=[50EF3850:01CC89C1]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18448.000
X-TM-AS-Result: No--12.896600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 09:19 AM, Markus Rechberger wrote:
> On Thu, Oct 13, 2011 at 4:58 PM, Alan Stern<stern@rowland.harvard.edu>  wrote:

>> This is very interesting.  There are only two things that could be
>> happening: Either the device sends different data during the two tests,
>> or there's a bug in the kernel.

> Before that I insist that this patch will go into the kernel (I know
> that sounds ridiculous but so far I did everything
> you requested me to do), I clearly pointed out that we even have hardware
> specs which can influence the transfer buffer. The patch does not hurt
> and makes the device work.

That makes no sense.  If there's a bug in the hardware we likely don't 
want to make global changes to work around it--a more targeted fix may 
be more appropriate.

If there is a bug in the kernel, why would we want a bandaid patch that 
just happens to make it work rather than a true fix?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
