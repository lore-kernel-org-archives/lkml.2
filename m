Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab1CaR67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:58:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51930 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab1CaR66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110331174334.GA414@core.coreip.homeip.net>
References: <1301592052-4064-1-git-send-email-manoj.iyer@canonical.com>
	<1301592052-4064-2-git-send-email-manoj.iyer@canonical.com>
	<20110331174334.GA414@core.coreip.homeip.net>
Date: Thu, 31 Mar 2011 12:58:57 -0500
Message-ID: <AANLkTi=a1eZS2fjxKYzf1RsE=6n9wZwUTPs8v84zb6p_@mail.gmail.com>
Subject: Re: [PATCH] add support for Lenovo tablet ID (0xE6)
From: Chris Bagwell <chris@cnpbagwell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        pingc@wacom.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:43 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Mar 31, 2011 at 12:20:52PM -0500, Manoj Iyer wrote:
>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>> ---
>>  drivers/input/tablet/wacom_wac.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
>> index 5597637..f751224 100644
>> --- a/drivers/input/tablet/wacom_wac.c
>> +++ b/drivers/input/tablet/wacom_wac.c
>> @@ -1364,6 +1364,8 @@ static const struct wacom_features wacom_features_0xE2 =
>>       { "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
>>  static const struct wacom_features wacom_features_0xE3 =
>>       { "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
>> +static const struct wacom_features wacom_features_0xE6 =
>> +     { "ISD-V4",               WACOM_PKGLEN_TPC2FG,    27760, 15694,  255,  0, TABLETPC2FG };
>
> Manoj, shouldn't we call it "Wacom ISDv4 E6" to be consistent?

I think its best to rename to be consistent with others in series.

>
> Ping, is resolution the same as with other "ISDv4"s?

My guess is yes.

Note: There is a patch from Ping that you recently accepted but I do
not see on a branch yet (maybe I'm looking in wrong place).  In it,
Ping replaces all resolution values with #defines and they are metric
based (aligns with synaptics) instead of these based on inches.

This patch is on version before that patch.

When convering over, it looks like value of 100/WACOM_INTUOS_RES is
the value to use here.

>
> Thanks,
>
> --
> Dmitry
>
