Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab0KPDIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:08:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61969 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab0KPDIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:08:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6168"; a="62799418"
Message-ID: <4CE1F5B4.3010001@codeaurora.org>
Date: Tue, 16 Nov 2010 08:38:36 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Anirudh Ghayal <aghayal@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC v1 PATCH 5/6] input: pmic8058-othc: Add support for PM8058
 based OTHC
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-6-git-send-email-tsoni@codeaurora.org>
In-Reply-To: <1289393281-4459-6-git-send-email-tsoni@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 11/10/2010 6:18 PM, Trilok Soni wrote:
> From: Anirudh Ghayal <aghayal@codeaurora.org>
> 
> One-touch headset controller is a hardware module in Qualcomm's PMIC8058.
> It supports headset insert/remove and switch press/release detection events
> over 3 MIC BIAS lines. The MIC BIAS lines can be configured to support
> headset detection or act as regular BIAS lines.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
> ---

Any comments on this patch?

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
