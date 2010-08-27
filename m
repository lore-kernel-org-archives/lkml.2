Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0H0QGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:06:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24658 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0H0QGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:06:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52338389"
Message-ID: <4C77E274.1090206@codeaurora.org>
Date: Fri, 27 Aug 2010 12:06:12 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH v3 0/1] input: mouse: add qci touchpad driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: http://lkml.indiana.edu/hypermail/linux/kernel/1008.1/01838.html

Changes since v2:
use #define for wait length during init, as suggested by Shubhrajyoti Datta
add error check from gpio_direction_input
move struct i2c_device_id closer to its use in i2c_driver, for clarity

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
