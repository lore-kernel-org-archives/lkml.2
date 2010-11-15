Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab0KORTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:19:17 -0500
Received: from daytona.panasas.com ([67.152.220.89]:59275 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab0KORTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:19:16 -0500
Message-ID: <4CE16B8E.1000300@panasas.com>
Date: Mon, 15 Nov 2010 19:19:10 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Vladislav Bolkhovitin <vst@vlnb.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com>
In-Reply-To: <20101115161620.GB5981@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2010 17:19:15.0057 (UTC) FILETIME=[3A4D1E10:01CB84E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 06:16 PM, Greg KH wrote:
> On Mon, Nov 15, 2010 at 11:46:38AM +0200, Boaz Harrosh wrote:
>> All these issues we were discussing are interesting and are real Kernel
>> problems. For instance the last comment you made was that for such a dynamic
>> system and life time problems, and functionality. A better and expected
>> solution might be the device tree and not sysfs.
> 
> Yes, that is what I have been saying for a while now.
> 
> Again:
> 	This code is using kobjects incorrectly.
> 	This code should not be using kobjects.
> 
> this is my last response to this thread now, and I'm sure you can
> understand why.
> 
> thanks,
> 
> greg k-h

Thank you Greg for your time and most valuable input.
I'm sorry for not understanding your position. I needed the
clear cut statement:

	This code should not be using kobjects. i.e not belong in sysfs

SCST guys. This sounds pretty clear cut to me. Sysfs was not built
in mind for such dynamic systems, and it will cause never ending
conflicts with future maintenance of sysfs vs SCST.

Perhaps consider a new alternative like the device tree as Greg suggested
or maybe finally accept the harsh realities of ConfigFS, and come join us
in the LIO project. SCST is a most valuable project and community which
we would like to join forces with in making Linux the best.

Lets call it Linux-Target and unify all our efforts.

Boaz
