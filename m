Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2DQKtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:49:04 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:53980 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2DQKtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:49:03 -0400
Message-ID: <4F8D4A95.8070103@bootc.net>
Date: Tue, 17 Apr 2012 11:48:53 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120410 Thunderbird/12.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 00/11] firewire-sbp-target: FireWire SBP-2 SCSI target
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>  <1334154043-69076-1-git-send-email-bootc@bootc.net>  <1334286222.3137.4877.camel@haakon2.linux-iscsi.org>  <4F882745.4080301@bootc.net> <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2012 02:23, Nicholas A. Bellinger wrote:
>>> This looks to me like a reasonable candidate for a v3.5 mainline merge,
>>> so we need to go ahead and get this into target-pending..  Also, thanks
>>> for getting Stefan's ACK's here on the drivers/firmware/ specific
>>> changes..
>>>
>>> So for new fabric drivers (as discused with Sebastian and usb-gadget
>>> recently) that the target team has been enforcing that new fabric
>>> modules convert to use a single source / header file for readability and
>>> maintainability purposes.
>>>
>>> It would be great if you can publish one more branch (no need to re-post
>>> the full diff) that takes your patch-v3 down to a single .c/.h file.
>>> Otherwise, I'm fine to take the 15 minutes to do this conversion ahead
>>> of dropping into target-pending for the sunday night linux-next build.
>> I'll get onto it over the weekend, I hope. I assume in this case I just
>> stick it all in drivers/target/ instead of having a sbp/ directory
>> underneath that?
>>
> I was eager to see this change, so I decided to go ahead and do the
> mechanical conversion myself in the following branch:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core.git sbp-merge
>
> As mentioned, it converts drivers/target/sbp/ to use a single sbp_target.[c,h]
> source/header file following mainline convention for new target fabric
> drivers.  Also make as many functions as possible statically defined and
> add inline prototypes where necessary.
>
> This patch also renames the sbp-target config entry from:
>
>      FIREWIRE_SBP_TARGET ->  SBP_TARGET
>
> and also renames the final generated module name from:
>
>      fireware-sbp-target.ko ->  sbp_target.ko

Nick,

I only just noticed this, but it looks like your merge lost my changed 
to the MAINTAINERS file. Want me to send a fixup patch?

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net

