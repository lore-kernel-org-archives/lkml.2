Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1LEEZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 23:25:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1LEEZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 23:25:27 -0500
MIME-Version: 1.0
In-Reply-To: <4ED8C029.7000004@ru.mvista.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
	<1322817178-8931-3-git-send-email-ming.lei@canonical.com>
	<4ED8C029.7000004@ru.mvista.com>
Date: Mon, 5 Dec 2011 12:25:24 +0800
Message-ID: <CACVXFVOUaodnMKV8_E7E__Zqt8c8Qt0+omgABj9cHbwyiQGoxA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/7] omap4: build fdif omap device from hwmod
From: Ming Lei <ming.lei@canonical.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 2, 2011 at 8:10 PM, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Hello.
>
>
> On 02-12-2011 13:12, Ming Lei wrote:
>
>> Signed-off-by: Ming Lei<ming.lei@canonical.com>
>> ---
>>  arch/arm/mach-omap2/devices.c |   33 +++++++++++++++++++++++++++++++++
>>  1 files changed, 33 insertions(+), 0 deletions(-)
>
>
>> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
>> index 1166bdc..a392af5 100644
>> --- a/arch/arm/mach-omap2/devices.c
>> +++ b/arch/arm/mach-omap2/devices.c
>> @@ -728,6 +728,38 @@ void __init omap242x_init_mmc(struct
>> omap_mmc_platform_data **mmc_data)
>>
>>  #endif
>>
>> +static struct platform_device* __init omap4_init_fdif(void)
>
>
>   Shouldn't there be space before *? checkpatch.pl is silent about it?
> ALso, I'd have placed '__init' after 'static'...

Yes, you are right, will do do it in next version.

>
>> +{
>> +       int id = -1;
>> +       struct platform_device *pd;
>> +       struct omap_hwmod *oh;
>> +       const char *dev_name = "fdif";
>
>
>   Why you need this variable at all?

Will remove some of them.

thanks,
--
Ming Lei
