Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164Ab0HMJes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:34:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43950 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934145Ab0HMJeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:34:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6072"; a="50762825"
Message-ID: <4C6511AD.4060800@codeaurora.org>
Date: Fri, 13 Aug 2010 15:04:37 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: Neil Leeder <nleeder@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <0680EC522D0CC943BC586913CF3768C003B3909F9C@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B3909F9C@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

>> +
>> +gpio_request_fail:
>> +	input_unregister_device(context->qcitp_dev);
>> +	context->qcitp_dev = NULL;
>> +
>> +register_fail:
>> +	input_free_device(context->qcitp_dev);
> You may like to revisit the use of free after unregister.
> 

That looks OK, because qcitp_dev is set to NULL before this call.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
