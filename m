Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0IRFtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 01:49:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37858 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab0IRFtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 01:49:42 -0400
Message-ID: <4C9452C6.8010308@ti.com>
Date: Sat, 18 Sep 2010 00:48:54 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Lnus Walleij <linus.walleij@stericsson.com>,
        Phil <ext-phil.2.carmody@nokia.com>,
        Kevin <khilman@deeprootsystems.com>
Subject: Re: [PATCH v2] power: introduce library for device-specific OPPs
References: <1284787459-25643-1-git-send-email-nm@ti.com> <20100918053849.GA19709@suse.de> <4C945139.20602@ti.com>
In-Reply-To: <4C945139.20602@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Menon, Nishanth had written, on 09/18/2010 12:42 AM, the following:
> Greg KH had written, on 09/18/2010 12:38 AM, the following:
>> On Sat, Sep 18, 2010 at 12:24:19AM -0500, Nishanth Menon wrote:
>>> This is hence introduced under lib allowing all architectures to
>>> selectively enable the feature based on their capabilities.
>> <snip>
>>
>>>  Documentation/power/00-INDEX |    2 +
>>>  Documentation/power/opp.txt  |  326 ++++++++++++++++++++++++++
>>>  drivers/base/power/Makefile  |    1 +
>>>  drivers/base/power/opp.c     |  527 ++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/opp.h          |  126 ++++++++++
>>>  kernel/power/Kconfig         |   14 ++
>>>  6 files changed, 996 insertions(+), 0 deletions(-)
>>>  create mode 100644 Documentation/power/opp.txt
>>>  create mode 100644 drivers/base/power/opp.c
>>>  create mode 100644 include/linux/opp.h
>> That doesn't look like the files are under lib/
>>
>> Did you forget to move them, or do you need to update the changelog
>> message?
> 
> Aww... and I thought I fixed them all.. the commit message is wrong.
> we had an alignment earlier today to move it from lib to 
> drivers/base/power [1] :(
> 
> Thanks for catching it. Will fix it in rev 3 after collating any further 
> comments as well.
> 
> [1] http://marc.info/?l=linux-arm-kernel&m=128476405731191&w=2
Yikes..sleepy eyes and long threads don't go well together :(

[1] http://marc.info/?l=linux-arm-kernel&m=128476651001280&w=2 is the 
link I had intended

apologies on the spam.. :(
-- 
Regards,
Nishanth Menon
