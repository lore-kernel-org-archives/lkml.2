Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab2AKVu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:50:29 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58598 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932504Ab2AKVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:50:28 -0500
Message-ID: <4F0E11C1.3020405@xenotime.net>
Date: Wed, 11 Jan 2012 14:48:33 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Subject: Re: [RFC 0/14] Finish up irq_domain generalization
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca> <4F0E017B.9060602@xenotime.net> <CACxGe6tYrnM6MrFS3hmqRiiKR1G_uECKhp2bgV49sW7soapuQw@mail.gmail.com> <CACxGe6v0YcxsmidFhe=s3EiDrYDoYBZLyk1MZjyg8uXRFGSvoQ@mail.gmail.com>
In-Reply-To: <CACxGe6v0YcxsmidFhe=s3EiDrYDoYBZLyk1MZjyg8uXRFGSvoQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 01:23 PM, Grant Likely wrote:
> On Wed, Jan 11, 2012 at 1:50 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Wed, Jan 11, 2012 at 2:39 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>> On 01/11/2012 12:22 PM, Grant Likely wrote:
>>>> Here are the patches that I've been working on to finish up the creation
>>>> of the generic irq_domain infrastructure.
>>>
>>> Does this fix the linux-next build problems that I have reported?
>>>
>>> https://lkml.org/lkml/2012/1/9/318
>>
>> IIRC, that was solved and a fix merged.  The problem was a driver
>> selecting CONFIG_IRQ_DOMAIN when it must not do so.  I'm build testing
>> with that randconfig now to make sure.
> 
> Yes, doing oldconfig on that sample no longer has CONFIG_IRQ_DOMAIN
> selected, so it looks okay.

Thanks.  I never saw a patch for it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
