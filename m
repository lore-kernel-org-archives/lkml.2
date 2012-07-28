Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2G1PHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 11:07:04 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34686 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752449Ab2G1PHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 11:07:02 -0400
Message-ID: <5013FFD4.80501@xenotime.net>
Date: Sat, 28 Jul 2012 08:05:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: fix DOCBOOKS=... building
References: <1339577020.4519.19.camel@jlt3.sipsolutions.net>	 <5013162C.9030606@xenotime.net> <1343474795.4980.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343474795.4980.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2012 04:26 AM, Johannes Berg wrote:

> On Fri, 2012-07-27 at 15:29 -0700, Randy Dunlap wrote:
>> On 06/13/2012 01:43 AM, Johannes Berg wrote:
>>
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Prior to 
>>> commit 4266129964b8238526936d723de65b419d8069c6
>>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Date:   Tue May 31 16:27:44 2011 -0300
>>>
>>>     [media] DocBook: Move all media docbook stuff into its own directory
>>>
>>> it was possible to build only a single (or more)
>>> book(s) by calling, for example
>>> 	make htmldocs DOCBOOKS=80211.xml
>>>
>>> This now fails:
>>> cp: target `.../Documentation/DocBook//media_api' is not a directory
>>>
>>> Ignore errors from that copy to make this possible again.
>>>
>>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>> ---
>>> I complained about this a long time ago, but now it finally bothered me
>>> enough to fix it ... :-)
>>
>>
>> Thanks.
>>
>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Can you apply it somewhere, or should I send it to Andrew, or do you
> have any other ideas?


I'm no longer the Documentation maintainer, but Rob Landley
could merge it.  You probably will need to resend it to him.

-- 
~Randy
