Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0KLIxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:53:08 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7475 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0KLIxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:53:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6164"; a="61703907"
Message-ID: <4CDD006D.1050709@codeaurora.org>
Date: Fri, 12 Nov 2010 14:23:01 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Anirudh Ghayal <aghayal@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [RFC v1 PATCH 6/6] drivers: rtc: Add support for Qualcomm PMIC8058
 RTC
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-7-git-send-email-tsoni@codeaurora.org>
In-Reply-To: <1289393281-4459-7-git-send-email-tsoni@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On 11/10/2010 6:18 PM, Trilok Soni wrote:
> From: Anirudh Ghayal <aghayal@codeaurora.org>
> 
> PMIC8058 is Qualcomm's power management IC. A
> 32-bit RTC is housed inside this PMIC. The RTC driver
> uses SSBI to communicate with the RTC module.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>

Please review this driver. Thanks.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
