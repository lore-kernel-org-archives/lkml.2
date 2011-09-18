Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1IRSmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 14:42:17 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:50950 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756136Ab1IRSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 14:42:16 -0400
Message-ID: <4E763B84.80009@xenotime.net>
Date: Sun, 18 Sep 2011 11:42:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jason Baron <jbaron@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com,
        bvanassche@acm.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
Subject: Re: [PATCH ] dynamic_debug: call __netdev_printk only for CONFIG_NET
References: <cover.1313085588.git.jbaron@redhat.com> <5514795fe63ccfd4b3a80283ed04a526abe3c59d.1313085588.git.jbaron@redhat.com> <201109011657.02407.arnd@arndb.de> <20110901151817.GA14324@redhat.com> <20110918082736.GB19444@kroah.com> <4E76288A.4020801@xenotime.net> <20110918182714.GA32615@kroah.com>
In-Reply-To: <20110918182714.GA32615@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 11:27 AM, Greg KH wrote:
> On Sun, Sep 18, 2011 at 10:21:14AM -0700, Randy Dunlap wrote:
>> On 09/18/2011 01:27 AM, Greg KH wrote:
>>> On Thu, Sep 01, 2011 at 11:18:18AM -0400, Jason Baron wrote:
>>>> On Thu, Sep 01, 2011 at 04:57:02PM +0200, Arnd Bergmann wrote:
>>>>> __netdev_printk is only defined when CONFIG_NET is set. Since we only need
>>>>> __dynamic_netdev_dbg for network drivers, we can make it conditional on the
>>>>> same Kconfig symbol.
>>>>>
>>>>
>>>> Hi,
>>>>
>>>> Yes, I've posted a fix for this:
>>>>
>>>> https://lkml.org/lkml/2011/8/30/297
>>>>
>>>> Hopefully, it will be pulled in soon.
>>>
>>> As that thread again spun off into confusion, can you please resend the
>>> end result?
>>
>> That spinning confusion had nothing to do with the posted & correct patch
>> which could have been applied several weeks ago.
>>
>> I'm curious:  Do you delete most of your email on a routine basis?
> 
> No, only after going through pending patches do I purge them.  And when
> a series of patches generates a thread like this one, where people are
> arguing over the way the macros are named, and no one seems to agree, I
> will take it as the fact that this series was contentious and needs to
> be resent after taking into consideration the original complaints.

Sheesh.  The naming of the macros has nothing to do with this build fix.

> For me to keep all email threads, based on the amount of email I get[1],
> would be ludicrous.
> 
> greg k-h
> 
> [1]: http://www.kroah.com/log/linux/get_lots_of_email.html


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
