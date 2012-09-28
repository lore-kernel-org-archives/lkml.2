Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2I1S0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:26:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54260 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab2I1S0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:26:10 -0400
Message-ID: <5065EBC0.2010105@linaro.org>
Date: Fri, 28 Sep 2012 12:26:08 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 18/57] power: Add sysfs interfaces for capacity
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org> <1348589574-25655-19-git-send-email-mathieu.poirier@linaro.org> <20120927070815.GI8836@lizard>
In-Reply-To: <20120927070815.GI8836@lizard>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-09-27 01:08 AM, Anton Vorontsov wrote:
> On Tue, Sep 25, 2012 at 10:12:15AM -0600, mathieu.poirier@linaro.org wrote:
>> From: Daniel WILLERUD <daniel.willerud@stericsson.com>
>>
>> Switchable depending on whether capacity scaling is enabled
>>
>> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
>> Signed-off-by: Daniel WILLERUD <daniel.willerud@stericsson.com>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
>> ---
>>  drivers/power/ab8500_fg.c |   57 ++++++++++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 56 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
>> index 8507254..46010ec 100644
>> --- a/drivers/power/ab8500_fg.c
>> +++ b/drivers/power/ab8500_fg.c
>> @@ -266,7 +266,6 @@ static enum power_supply_property ab8500_fg_props[] = {
>>  	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
>>  	POWER_SUPPLY_PROP_CHARGE_FULL,
>>  	POWER_SUPPLY_PROP_CHARGE_NOW,
>> -	POWER_SUPPLY_PROP_CAPACITY,
> [...]
>> +static struct device_attribute ab8500_fg_sysfs_psy_attrs[] = {
>> +	__ATTR(capacity, S_IRUGO, ab8500_show_capacity, NULL),
>> +};
> 
> I don't understand the rationale behind this patch. Why remove normal
> power supply property, and make your own with the same name? Something
> isn't right...

The similarity in the naming convention it a coincidence here.  In one
case it's a enum and the other sysfs attribute.  Could you expand on
your suspicions ?

> 

