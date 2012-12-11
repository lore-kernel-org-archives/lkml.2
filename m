Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab2LKACY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:02:24 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:43694 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2LKACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:02:23 -0500
Message-ID: <50C677D9.5070109@ahsoftware.de>
Date: Tue, 11 Dec 2012 01:01:29 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C6603E.5070909@ahsoftware.de> <50C66406.9090606@metafoo.de>
In-Reply-To: <50C66406.9090606@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.12.2012 23:36, schrieb Lars-Peter Clausen:
> Well, I've been exaggerating a bit, you can call it multiple times, but you

Thanks a lot for the explanation(s).

>>>> +error_free_drvdata:
>>>> +    platform_set_drvdata(pdev, NULL);
>>>
>>> Setting the platform data to NULL should not be necessary. Some
>>> drivers do
>>> this but it's kind of the result of cargo-cult-coding.
>>>
>>>> +    kfree(time_state);

Btw. I wouldn't call that cargo-cult-coding. It's more defensive 
programming as people might not be sure, if there is something around 
which still might access the platform data at that point. Ok, there 
would be a need for a mutex or similiar if that really could happen, but 
I wouldn't call such practices cargo-cult. ;)

Regards,

Alexander

