Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2KGCWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 21:22:20 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50803 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab2KGCWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 21:22:19 -0500
MIME-Version: 1.0
In-Reply-To: <1352248203.29589.234.camel@haakon2.linux-iscsi.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
	<1352156701-4038-78-git-send-email-keescook@chromium.org>
	<1352248203.29589.234.camel@haakon2.linux-iscsi.org>
Date: Tue, 6 Nov 2012 18:22:17 -0800
X-Google-Sender-Auth: wm7DdKSANr7XTG-3RAbEsq0roQc
Message-ID: <CAGXu5jJ6X2hwbN5_ULWoVrpekXF=H2BDyAa38u8MRHJt_nVGUA@mail.gmail.com>
Subject: Re: [PATCH 077/104] drivers/target/sbp: remove depends on CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 4:30 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Mon, 2012-11-05 at 15:04 -0800, Kees Cook wrote:
>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
>> while now and is almost always enabled by default. As agreed during the
>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>>
>> CC: Chris Boot <bootc@bootc.net>
>> CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/target/sbp/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/sbp/Kconfig b/drivers/target/sbp/Kconfig
>> index 132da54..1614bc7 100644
>> --- a/drivers/target/sbp/Kconfig
>> +++ b/drivers/target/sbp/Kconfig
>> @@ -1,6 +1,6 @@
>>  config SBP_TARGET
>>       tristate "FireWire SBP-2 fabric module"
>> -     depends on FIREWIRE && EXPERIMENTAL
>> +     depends on FIREWIRE
>>       help
>>         Say Y or M here to enable SCSI target functionality over FireWire.
>>         This enables you to expose SCSI devices to other nodes on the FireWire
>
> Looks fine to drop this usage for sbp-target.
>
> Do you want this patch to be include into the target-pending/for-next ->
> for-3.8 branch, or are you planning to take this full series upstream
> through a different tree..?

Stephen has asked that maintainers take the patches into their trees
when possible. I'm going to carry any patches that don't find a home,
so it's up to you; just let me know. :)

-Kees

-- 
Kees Cook
Chrome OS Security
