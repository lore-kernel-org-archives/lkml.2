Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0IEO2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 10:28:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35307 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0IEO2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 10:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=9F1HpUyhGOp0TJdazoshKgxbFkyqWvztb5OeH@mail.gmail.com>
References: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
	<AANLkTi=9F1HpUyhGOp0TJdazoshKgxbFkyqWvztb5OeH@mail.gmail.com>
Date: Sun, 5 Sep 2010 09:28:38 -0500
Message-ID: <AANLkTimMhAkdfNbju7ckFr-oSQrMcSTmX2sdstGMP_cb@mail.gmail.com>
Subject: Re: [PATCH 0/5] input: wacom: Initial support for Bamboo (rev3)
From: Chris Bagwell <chris@cnpbagwell.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pingc@wacom.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 4, 2010 at 4:24 PM, Ping Cheng <pinglinux@gmail.com> wrote:
> On Saturday, September 4, 2010, Henrik Rydberg <rydberg@euromail.se> wrote:
>> This the fourth iteration of the Bamboo patches. Hopefully no big
>> surprises.  The ordering has changed to allow setting the pressure_max
>> which is not parsed in the hid function. Ping's button mapping has
>> been implemented, relying on middle-button emulation instead.  The
>> lowres quirks now apply to all touch devices in the family.
>
> Thank you Henrik for the patchset. Very much appreciated.
>
> Acked-by: Ping Cheng < pingc@wacom.com>  for the series.
>
> Ping

Thanks for addressing my comments/questions.

Also, Thanks for placing all the hooks for future pen support as well.
 I'll be following up with a patch set for that once your finished.
If there are any remaining pen specific issues, feel free to offload
it on me.

Chris

>
>> Henrik Rydberg (4):
>>   input: wacom: Add fuzz parameters to features
>>   input: wacom: Collect device quirks into single function (rev2)
>>   input: wacom: Add support for the Bamboo Touch trackpad (rev4)
>>   input: wacom: Add a quirk for lowres Bamboo devices (rev2)
>>
>> Ping Cheng (1):
>>   input: wacom: Parse the Bamboo device family
>>
>>  drivers/input/tablet/wacom.h     |    1 +
>>  drivers/input/tablet/wacom_sys.c |   57 +++++++++++++-----
>>  drivers/input/tablet/wacom_wac.c |  123 +++++++++++++++++++++++++++++++++++++-
>>  drivers/input/tablet/wacom_wac.h |   14 ++++
>>  4 files changed, 176 insertions(+), 19 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
