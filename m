Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049Ab0HFUcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:32:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27166 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762015Ab0HFUcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:32:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6066"; a="50027935"
Message-ID: <4C5C713D.8010902@codeaurora.org>
Date: Fri, 06 Aug 2010 16:31:57 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Leeder <nleeder@codeaurora.org>
Subject: [PATCH 0/1] mouse: add qci touchpad driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update of the driver that Quanta posted here a few days ago. 
Quanta wrote the original version of the driver and I am picking up 
maintenance for code aurora forum.

I've addressed the review comments. The only one that's outstanding is 
the use of the sensitivity value. I don't see an easy way that userspace 
would be able to apply the sensitivity scaling between the driver and 
say xorg, so for now I've left it in the driver, but I'd welcome any 
suggestions for improvement.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
