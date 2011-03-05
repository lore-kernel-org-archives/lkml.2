Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1CEVk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 16:40:29 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55798 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1CEVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 16:40:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6276"; a="78241092"
Message-ID: <ae824b511bff00411fa33086cb529c32.squirrel@www.codeaurora.org>
In-Reply-To: <4D716AD5.1070403@codeaurora.org>
References: <1299276551-11978-1-git-send-email-sheetals@codeaurora.org>
    <4D716AD5.1070403@codeaurora.org>
Date: Sat, 5 Mar 2011 13:40:07 -0800 (PST)
Subject: Re: [PATCH 0/3] ARM: Add Scorpion/ScorpionMP support to perf and 
     Oprofile
From: "Sheetal Sahasrabudhe" <sheetals@codeaurora.org>
To: "Bryan Huntsman" <bryanh@codeaurora.org>
Cc: "Sheetal Sahasrabudhe" <sheetals@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        jamie.iles@picochip.com, jean.pihet@newoldbits.com,
        robert.richter@amd.com, dwalker@fifo99.com, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

> Some minor comments from a quick review:
> - you're using multi-line commenting style for single line comments
> - see Documentation/CodingStyle, Chapter 8, for preferred multi-line
> commenting style
I will fix the commenting style wherever needed.

> - 'mv perf_event_qc.c perf_event_msm.c'?
That's fine with me.

Thanks,
Sheetal

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.



