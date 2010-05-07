Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0EGT5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:57:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39010 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab0EGT5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:57:23 -0400
Message-ID: <4BE47059.8090101@zytor.com>
Date: Fri, 07 May 2010 12:56:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>	 <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>	 <1273258266.1540.63.camel@Joe-Laptop.home>	 <20100507200208.09b2941d@lxorguk.ukuu.org.uk> <1273259187.1540.75.camel@Joe-Laptop.home>
In-Reply-To: <1273259187.1540.75.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 12:06 PM, Joe Perches wrote:
> On Fri, 2010-05-07 at 20:02 +0100, Alan Cox wrote:
>> On Fri, 07 May 2010 11:51:06 -0700
>> Joe Perches <joe@perches.com> wrote:
>>> On Fri, 2010-05-07 at 10:41 -0700, Jacob Pan wrote: 
>>>> +	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
>>>> +	"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
>>> Even though many of the rtc drivers print this way, it seems
>>> a very backwards way of presenting time to me.
>> Consistency is really more important here IMHO - lots of drivers have set
>> an existing policy.
> 
> (added Alessandro Zummo to cc's)
> 
> look at drivers/rtc.
> 
> All of them seem to use a templated copy/paste dev_dbg,
> which seems to point to a use for a possible common rtc_util.c
> or some such where this could be standardized.
>  
> Is there somewhere else this style is used?
> 

Probably the right thing to do is to (a) move all this printing to
common code; (b) change to ISO 8601 format.

	-hpa

