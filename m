Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0HSUPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:15:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49470 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HSUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lMFHz6fR7Z+g0AXBwW/svz9dkD+IxrlJA8fKJIlZmrWN5JOwrTrzhpmzWsCPuSE4UU
         BOMUpBD9pg0NZbCQ+HO+N6Ixhq1Wsn3ounwKnneNHkWhg9knuHKiOCmw4+pzYwO9cO9F
         8Vsv/2eaN5ecjX8V3n0EEQlruZyuUO9UliNro=
Message-ID: <4C6D90DC.4050202@garzik.org>
Date: Thu, 19 Aug 2010 16:15:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@google.com>
Subject: Re: linux-next: build failure after merge of the libata tree
References: <20100818104057.5fdaf20d.sfr@canb.auug.org.au> <AANLkTinJ8ks85Ym11wd4csdqFVgQpS7nw=RrfhMrLPUH@mail.gmail.com>
In-Reply-To: <AANLkTinJ8ks85Ym11wd4csdqFVgQpS7nw=RrfhMrLPUH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 08:46 PM, Gwendal Grignou wrote:
> Let me fix it and send a patch to Jeff.
>
> Gwendal.
>
> On Tue, Aug 17, 2010 at 5:40 PM, Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>> Hi Jeff,
>>
>> After merging the libata tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>>
>> drivers/ata/libata-transport.c: In function 'ata_attach_transport':
>> drivers/ata/libata-transport.c:678: error: implicit declaration of function 'kzalloc'
>> drivers/ata/libata-transport.c:678: warning: assignment makes pointer from integer without a cast
>> drivers/ata/libata-transport.c: In function 'ata_release_transport':
>> drivers/ata/libata-transport.c:741: error: implicit declaration of function 'kfree'
>>
>> Caused by commit 97395d39931160a171959ac2e1fbff1caba3374b ("[libata] Add
>> ATA transport class") neglecting to include linux/slab.h.   See Rule 1 in
>> Documentation/SubmitChecklist.
>>
>> I have used the libata tree form next-20100817 for today.


Never received a patch; pushed out the obvious fix myself.

