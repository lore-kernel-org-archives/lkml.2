Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1LAPB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:01:27 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45732 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1LAPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:01:25 -0500
Message-ID: <4ED796AF.60606@linux.vnet.ibm.com>
Date: Thu, 01 Dec 2011 20:31:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspend and resume on ASUS Laptops
References: <1322712689.30977.11.camel@frodo> <201112011248.44449.oneukum@suse.de> <1322749734.30977.16.camel@frodo> <201112011538.06912.oneukum@suse.de>
In-Reply-To: <201112011538.06912.oneukum@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11120104-5140-0000-0000-00000059DD61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 08:08 PM, Oliver Neukum wrote:

> Am Donnerstag, 1. Dezember 2011, 15:28:54 schrieb Steven Rostedt:
>> On Thu, 2011-12-01 at 12:48 +0100, Oliver Neukum wrote:
>>
>>> What errors are seen in the kernel log?
>>
>> Without the script, I don't see any errors. Is there some debug thing
>> you want me to do? There's no error messages but the system just hangs
>> on suspend. It never makes it to the suspend state. The only way out of
>> it is to press and hold the power button for 10 seconds to force a hard
>> reboot.
> 
> I see. I thought the system just refuses to enter S3/4. That it hangs was
> new to me. Has there been a mail thread about this problem already?
> If not, what is the last thing you see if you go to S3 after you booted
> with no_console_suspend on the kernel command line?
> 


Hi Steven,
Since without the script your system refuses to suspend, you could also use the
'pm_test' framework (documented in Documentation/power/basic-pm-debugging.txt)
to find out more about the failing step when suspend is attempted without using
the script. Trying 'echo devices > /sys/power/pm_test' might be helpful in your
case.

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

