Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2LLKSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:18:53 -0500
Received: from smtp-out-245.synserver.de ([212.40.185.245]:1113 "EHLO
	smtp-out-245.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2LLKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:18:52 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3160
Message-ID: <50C85A0F.3040606@metafoo.de>
Date: Wed, 12 Dec 2012 11:18:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4 v3] rtc: add rtc-driver for HID sensors of type time
References: <50C73AFC.1050904@jic23.retrosnub.co.uk> <1355250106-3114-1-git-send-email-holler@ahsoftware.de> <1355250106-3114-4-git-send-email-holler@ahsoftware.de> <50C8539C.1070509@metafoo.de> <50C8591A.3030301@ahsoftware.de>
In-Reply-To: <50C8591A.3030301@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 11:14 AM, Alexander Holler wrote:
> Am 12.12.2012 10:51, schrieb Lars-Peter Clausen:
> 
>> Looks good, but as I wrote during the last review the __devinits need to go.
>> A few other suggerstions online
> 
> Oh, have forgotten it. Ok, will make a v4, changing the other few things too.
> 
>>> +    case HID_USAGE_SENSOR_TIME_MONTH:
>>> +        time_buf->tm_mon = --*(u8 *)raw_data;
> 
> Time sensors are sending the month in the range 1-12, not 0-11.
> 
Ah, sorry, I guess hadn't had enough coffee yet, I read this as -(-(*(u8
*)raw_data))) and was a bit confused...
