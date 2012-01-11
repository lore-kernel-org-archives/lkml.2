Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab2AKB40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:56:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58091 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab2AKB4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:56:25 -0500
MIME-Version: 1.0
In-Reply-To: <878vlf6rm5.fsf@rustcorp.com.au>
References: <1325951076.860.2.camel@mop> <871ur99vzf.fsf@rustcorp.com.au>
 <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com>
 <87zkdw7ayp.fsf@rustcorp.com.au> <1326214063.1038.1.camel@mop> <878vlf6rm5.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 10 Jan 2012 23:56:03 -0200
Message-ID: <CAMOw1v5JJyoqSF5aZV7ia_KyzT7PPVRAMRFwNOpPzGt8fgWTpw@mail.gmail.com>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jon Masters <jcm@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 9:54 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 10 Jan 2012 17:47:43 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: modules: sysfs - export: taint, coresize, initsize
>>
>> Recent tools do not want to use /proc to retrieve module information. A few
>> values are currently missing from sysfs to replace the information available
>> in /proc/modules.
>>
>> This adds /sys/module/*/{coresize,initsize,taint} attributes.
>>
>> TAINT_PROPRIETARY_MODULE (P) and TAINT_OOT_MODULE (O) flags are both always
>> shown now, and do no longer exclude each other, also in /proc/modules.
>>
>> Replace the open-coded sysfs attribute initializers with the __ATTR() macro.
>>
>> Add the new attributes to Documentation/ABI.
>>
>> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
>> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>
> Thanks, applied.
>

Nice to see this patch applied. I'll prepare the changes to kmod.

Thanks
Lucas De Marchi
