Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0FOB70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:59:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33066 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0FOB7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kgVMTSRyziU/yetJBYr+OiEwWOHmusZre2ZeL9LoxjZBB26VTa/7luf7/9w6kvy0D3
         /3uJ9HKgbOrT665L9f0vzhYid+tvLF6F0S6XppxFhtZZ7PPcEqJ2WPXYfWNDX4Ui2nod
         HKxz5lI0Q6ukJMNHK2yDsXlbVKnIY9Ikq4N7U=
Message-ID: <4C16DE8B.3010901@gmail.com>
Date: Mon, 14 Jun 2010 18:59:39 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] ieee1394: sbp2: remove unused code
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-8-git-send-email-justinmattock@gmail.com> <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de> <4C16AECD.50506@gmail.com> <tkrat.0ef352b3c2fae897@s5r6.in-berlin.de>
In-Reply-To: <tkrat.0ef352b3c2fae897@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 05:05 PM, Stefan Richter wrote:
> On 14 Jun, Justin P. Mattock wrote:
>> drivers/ieee1394/raw1394.c: In function 'arm_lock64':
>> drivers/ieee1394/raw1394.c:1373:11: warning: 'old' may be used
>> uninitialized in this function
>> drivers/ieee1394/raw1394.c: In function 'arm_lock':
>> drivers/ieee1394/raw1394.c:1155:12: warning: 'old' may be used
>> uninitialized in this function
>
> Thanks.  I briefly looked at this and am not sure if this is real or a
> false positive.  This code is old crud that is really hard to read.
>
> I will look at it again at a more convenient time of day.


I dont think you need to buddy!! just applied all
patches you sent..
she looks like this now:

   CC [M]  drivers/firewire/core-card.o
   CC [M]  drivers/firewire/core-cdev.o
   CC [M]  drivers/firewire/core-device.o
   CC [M]  drivers/firewire/core-iso.o
   CC [M]  drivers/firewire/core-topology.o
   CC [M]  drivers/firewire/core-transaction.o
   CC [M]  drivers/firewire/ohci.o
   CC [M]  drivers/firewire/sbp2.o
   LD [M]  drivers/firewire/firewire-core.o
   LD [M]  drivers/firewire/firewire-ohci.o
   LD [M]  drivers/firewire/firewire-sbp2.o
   CC      drivers/firmware/dmi_scan.o
   CC      drivers/firmware/efivars.o
   CC      drivers/firmware/dmi-id.o
   CC      drivers/firmware/memmap.o
   LD      drivers/firmware/built-in.o

she's clean as a whistle!!

only concern now is the
hardware and driver functioning properly
i.g. I haven't installed the kernel
(if it even makes a difference)
just compiling and looking at warning messages.

cheers,

Justin P. Mattock
