Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab2D2ODb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab2D2OD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:03:29 -0400
Message-ID: <4F9D49DC.6090002@redhat.com>
Date: Sun, 29 Apr 2012 11:02:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Joe Perches <joe@perches.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>  <1335291342-14922-1-git-send-email-mchehab@redhat.com>  <20120427133304.GE9626@aftab.osrc.amd.com> <4F9ADCE3.2030506@redhat.com>  <20120428091621.GE26065@aftab.osrc.amd.com> <1335632874.4191.8.camel@joe2Laptop>
In-Reply-To: <1335632874.4191.8.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-04-2012 14:07, Joe Perches escreveu:
> On Sat, 2012-04-28 at 11:16 +0200, Borislav Petkov wrote:
>> On Fri, Apr 27, 2012 at 02:52:35PM -0300, Mauro Carvalho Chehab wrote:
>>>> All those local variables should be sorted in a reverse christmas tree
>>>> order:
>>>>
>>>> 	u32 this_is_the_longest_array_name[LENGTH];
>>>> 	void *shorter_named_variable;
>>>> 	unsigned long size;
>>>> 	int i;
>>>>
>>>> 	...
>>>
>>> Why? There's nothing at the CodingStyle saying about how the vars should
>>> be ordered. If you want to enforce some particular order, please do it
>>> yourself, but apply it consistently among the entire subsystem.
>>
>> First of all, this way it is more readable.
> 
> Not in my opinion, and blindly using "reverse christmas tree"
> can separate variables that should be declared together.

I agree with Joe. The order won't make the code easier or harder to
read, nor it would improve code performance.

>> Second of all, maybe we should hold it down in CodingStyle.

Different developers have different opinions about how to order includes, 
functions, vars, etc. 

So, this is not at CodingStyle because there's no consensus about it, and 
because this is not relevant for code understanding.

A reviewer should not reject a patch just because he doesn't like the
order that the developer used.

Regards,
Mauro
