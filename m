Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0LGT5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:57:36 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:33883 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553Ab0LGT5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:57:34 -0500
Message-ID: <4CFE919A.1040704@euromail.se>
Date: Tue, 07 Dec 2010 20:57:14 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se> <20101207091653.GA22416@core.coreip.homeip.net>
In-Reply-To: <20101207091653.GA22416@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQ3f4-0004wt-CL.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQ3f4-0004wt-CL 77ca082e3db55723fc9dbfa9828e8122
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 10:16 AM, Dmitry Torokhov wrote:

> Hi Henrik,
> 
> On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
>> Today, userspace sets up an input device based on the data it emits.
>> This is not always enough; a tablet and a touchscreen may emit exactly
>> the same data, for instance, but the former should be set up with a
>> pointer whereas the latter does not need to. Recently, a new type of
>> touchpad has emerged where the buttons are under the pad, which changes
>> handling logic without changing the emitted data. This patch introduces
>> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
>> about the device resulting in proper setup.
> 
> If we agree that the new ioctl is suitable we'llalso need to wireit up
> through sysfs. Also, can we keep all definitions to INPUT_ namespace?
> 
> Thanks.
> 


Thanks all for the comments, this is what I extract from them:

* Split struct into separate calls, although this still seems debated.

* Use INPUT_ namespace

* Add sysfs version

* Keep bitmask for types. Is the list of types complete?

* Still only one data point for capabilities. Anything else?

Sounds about right?

Thanks,
Henrik
