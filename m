Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab0KOUkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:40:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53392 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141Ab0KOUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:39:59 -0500
Message-ID: <4CE19A8B.5010201@vlnb.net>
Date: Mon, 15 Nov 2010 23:39:39 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com>
In-Reply-To: <4CE16B8E.1000300@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:qmbzR6GsrgG6IhWuik1cn4iAeMhEVCGLKblOFv9/Iim
 HeoasF+qzF9v2upvafDXN+vq82QGFBcoa1ytLxUOTVl7ql5Rz2
 wcfA0+Q/POE2H59N1guRqqyDWPr0ibKcEY50TiWHPayhjCmuCn
 UrR430Cl8r809+8Q63ww1NlNhL1o9R8/VMQJpKJZY0lULODRfu
 UlhH/vkDrelEoD7v0EahQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh, on 11/15/2010 08:19 PM wrote:
> On 11/15/2010 06:16 PM, Greg KH wrote:
>> On Mon, Nov 15, 2010 at 11:46:38AM +0200, Boaz Harrosh wrote:
>>> All these issues we were discussing are interesting and are real Kernel
>>> problems. For instance the last comment you made was that for such a dynamic
>>> system and life time problems, and functionality. A better and expected
>>> solution might be the device tree and not sysfs.
>>
>> Yes, that is what I have been saying for a while now.
>>
>> Again:
>> 	This code is using kobjects incorrectly.
>> 	This code should not be using kobjects.
>>
>> this is my last response to this thread now, and I'm sure you can
>> understand why.
>>
>> thanks,
>>
>> greg k-h
> 
> Thank you Greg for your time and most valuable input.
> I'm sorry for not understanding your position. I needed the
> clear cut statement:
> 
> 	This code should not be using kobjects. i.e not belong in sysfs
> 
> SCST guys. This sounds pretty clear cut to me. Sysfs was not built
> in mind for such dynamic systems, and it will cause never ending
> conflicts with future maintenance of sysfs vs SCST.

As I explained in the previous e-mail, I believe, SYSFS perfectly suits
SCST and SCST perfectly suits SYSFS.

If you think it isn't so, let's discuss each showstopper for that, one
after one.

> Lets call it Linux-Target and unify all our efforts.

Looks like a great idea!

Thanks,
Vlad
