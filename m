Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1ISQtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:49:42 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:51135 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755013Ab1ISQtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:49:41 -0400
Message-ID: <4E7772A2.8010000@xenotime.net>
Date: Mon, 19 Sep 2011 09:49:38 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de,
        joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH ] dynamic_debug: call __netdev_printk only for CONFIG_NET
References: <cover.1313085588.git.jbaron@redhat.com> <5514795fe63ccfd4b3a80283ed04a526abe3c59d.1313085588.git.jbaron@redhat.com> <201109011657.02407.arnd@arndb.de> <20110901151817.GA14324@redhat.com> <20110918082736.GB19444@kroah.com> <20110919134814.GA2658@redhat.com>
In-Reply-To: <20110919134814.GA2658@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 06:48 AM, Jason Baron wrote:
> On Sun, Sep 18, 2011 at 01:27:36AM -0700, Greg KH wrote:
>> On Thu, Sep 01, 2011 at 11:18:18AM -0400, Jason Baron wrote:
>>> On Thu, Sep 01, 2011 at 04:57:02PM +0200, Arnd Bergmann wrote:
>>>> __netdev_printk is only defined when CONFIG_NET is set. Since we only need
>>>> __dynamic_netdev_dbg for network drivers, we can make it conditional on the
>>>> same Kconfig symbol.
>>>>
>>>
>>> Hi,
>>>
>>> Yes, I've posted a fix for this:
>>>
>>> https://lkml.org/lkml/2011/8/30/297
>>>
>>> Hopefully, it will be pulled in soon.
>>
>> As that thread again spun off into confusion, can you please resend the
>> end result?
>>
>> thanks,
>>
>> greg k-h
> 
> Hi,
> 
> Andrew Morton has pulled these into his -mm tree...so I think the series
> should be all set.

Good.  The build fix is still needed in today's linux-next (20110919).


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
