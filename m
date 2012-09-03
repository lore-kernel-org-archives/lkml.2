Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2ICJvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:51:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57930 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab2ICJvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:51:42 -0400
Message-ID: <50447D90.1090009@ti.com>
Date: Mon, 3 Sep 2012 15:21:12 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-doc@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] media: v4l2-ctrls: add control for test pattern
References: <1346663777-23149-1-git-send-email-prabhakar.lad@ti.com> <504477A1.6020304@samsung.com>
In-Reply-To: <504477A1.6020304@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Thanks for the review.

On Monday 03 September 2012 02:55 PM, Sylwester Nawrocki wrote:
> On 09/03/2012 11:16 AM, Prabhakar Lad wrote:
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 2d7bc15..ae709d1 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -430,6 +430,18 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>  		"Advanced Predictor",
>>  		NULL,
>>  	};
>> +	static const char * const test_pattern[] = {
>> +		"Test Pattern Disabled",
> 
> How about just "Disabled" ?
> 
Ok.

Thanks and Regards,
--Prabhakar Lad

>> +		"Vertical Lines",
>> +		"Horizontal Lines",
>> +		"Diagonal Lines",
>> +		"Solid Black",
>> +		"Solid White",
>> +		"Solid Blue",
>> +		"Solid Red",
>> +		"Checker Board",
>> +		NULL,
>> +	};
> 
> --
> 
> Regards,
> Sylwester
> 

