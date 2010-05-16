Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0EPMR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 08:17:29 -0400
Received: from honeysuckle.london.02.net ([87.194.255.144]:35287 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab0EPMR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 08:17:27 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 May 2010 08:17:27 EDT
X-Antivirus-MYDOMAIN-Mail-From: don@prince.homedns.org via fireman-smp.dhp.mpl
X-Antivirus-MYDOMAIN: 1.25-st-qms (Clear:RC:1(192.168.1.163):. Processed in 0.042299 secs Process 10288)
Message-ID: <4BEFE126.4080606@prince.homedns.org>
Date: Sun, 16 May 2010 13:12:22 +0100
From: "don@homedns" <don@prince.homedns.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100422 Mandriva/3.0.4-0.4mdv2010.0 (2010.0) Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Schedel <r.schedel@yahoo.de>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc7] HID: hid-samsung: add support for Creative
 Desktop Wireless 6000
References: <4BEF3D1F.6080403@yahoo.co.uk> <4BEFCA05.8000402@yahoo.de>
In-Reply-To: <4BEFCA05.8000402@yahoo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/10 11:33, Robert Schedel wrote:

> Hello,
>
> On 16.05.2010 02:32, Don Prince wrote:
>   
>> Add support for the Creative Desktop Wireless 6000 keyboard/mouse
>> bundle's multimedia buttons which are not currently handled by
>> the default/samsung HID driver.
>>
>> Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>
>>
>> ---
>> [...]
>>     
> As originator of the "old" 0419:0001 IrDA driver parts had a short look at it:
> - Merging with old code looks OK. Tested with old 0419:0001 (184) device, still functional.
> - 0419:0600 not yet known in usb.ids, might be worth a contribution
> - As you merged in a new device, and for explaining why this handling was added, my suggestion is to adapt the existing comments, e.g.:
>
> /*
>  * This driver supports several HID devices:
>  *
>  * [0419:0001] Samsung IrDA remote controller (reports as Cypress USB Mouse).
>  *
>  * There are several variants:
>  *
>  * 1. 184 byte report descriptor
> [...]
>  * [0419:0600] Creative Desktop Wireless 6000 keyboard/mouse combo
>  *
>  * Several key mappings used from the consumer usage page
>  * deviate from the USB HUT 1.12 standard.
>  */
>
> Of course some HID maintainer should also review it, for general policy.
>
> Regards,
> Robert Schedel
>
>   
Ok I'll add some comments and re-submit patch as v2.

Regards

Don Prince

