Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0KOKaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:30:13 -0500
Received: from natasha.panasas.com ([67.152.220.90]:45289 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0KOKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:30:11 -0500
X-Greylist: delayed 2531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2010 05:30:11 EST
Message-ID: <4CE1017E.4090409@panasas.com>
Date: Mon, 15 Nov 2010 11:46:38 +0200
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
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
References: <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com>
In-Reply-To: <20101113235938.GA1827@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2010 09:46:43.0697 (UTC) FILETIME=[02D45E10:01CB84AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 01:59 AM, Greg KH wrote:
> In the end, I guess it really doesn't matter as this code isn't getting
> merged so I shouldn't worry about it, right?
> 

This is not nice and is uncharacteristic of you.

This project, even though out-of-tree, is an old and mature project that
has many users. These are all *Linux* users. The authors and community
have come to us for help, and advice on making this code acceptable for
mainline and hardening the code the way, only one project on the planet
can do, the Linux community. I think it is our courtesy and obligation
to the Linux users of this Project to comment where they are doing wrong
and where they should do better.

It is not of their choice to be out-of-tree. It is ours. The least we can
do. Is give then some assistance if we can, and have 5 minutes of our time.

All these issues we were discussing are interesting and are real Kernel
problems. For instance the last comment you made was that for such a dynamic
system and life time problems, and functionality. A better and expected
solution might be the device tree and not sysfs. And for such big additions
the sysfs maintainer must give his blessings. This is most valuable information
regardless of if we accept their code or not at the end.
(And we better explain ourselves well when we don't)

> thanks,
> 
> greg k-h

Sincerely yours
Boaz
