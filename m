Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1KRTAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:00:39 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:59836 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754009Ab1KRTAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:00:37 -0500
Message-ID: <4EC6AADA.2040805@xenotime.net>
Date: Fri, 18 Nov 2011 10:58:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation for sysfs attributes for 3.3 (xen related)
References: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com> <4EC6A2D6.10702@xenotime.net> <20111118183313.GA7417@suse.de>
In-Reply-To: <20111118183313.GA7417@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 10:33 AM, Greg KH wrote:
> On Fri, Nov 18, 2011 at 10:24:22AM -0800, Randy Dunlap wrote:
>> On 11/18/2011 10:19 AM, Konrad Rzeszutek Wilk wrote:
>>> Please accept the following two patches that describe the
>>> SysFS of some of the Xen drivers. Thank you.
>>>
>>> David Vrabel (2):
>>>       xen: document balloon driver sysfs files
>>>       xen: document backend sysfs files
>>>
>>>  Documentation/ABI/stable/sysfs-bus-xen-backend     |   75 +++++++++++++++++++
>>>  .../ABI/stable/sysfs-devices-system-xen_memory     |   77 ++++++++++++++++++++
>>>  2 files changed, 152 insertions(+), 0 deletions(-)
>>
>> Hey,
>>
>> Documentation/ABI/ patches should go to GregKH.
> 
> Really?  I'm now in charge of the kernel ABI?

Well, you are the person who usually tells people that they need
to provide Documentation/ABI/ patches for sysfs files AFAICT.

> Ah, the power...

:(

> /me rubs his hands together
> 
>> Greg, can we clarify that in MAINTAINERS ?
> 
> Seriously, I'm not in charge of it, that's up to the subsystem for which
> the API comes from, I am not the one in charge of the whole thing.
> 
> So, for this type of patch, they should go through the xen subsystem
> maintainers directly.

Sounds good.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
