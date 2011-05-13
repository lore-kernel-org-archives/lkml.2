Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab1EMQZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:25:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25368 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1EMQZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:25:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6344"; a="91253501"
From: David Brown <davidb@codeaurora.org>
To: Mohan Pallaka <mpallaka@codeaurora.org>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.intradead.org,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        rmk@dyn-67.arm.linux.org.uk
Subject: Re: [PATCH 1/2] pwm: Add __weak attributed functions for pwm operations
References: <1305290602-29859-1-git-send-email-mpallaka@codeaurora.org>
	<1305290602-29859-2-git-send-email-mpallaka@codeaurora.org>
Date: Fri, 13 May 2011 09:25:28 -0700
In-Reply-To: <1305290602-29859-2-git-send-email-mpallaka@codeaurora.org>
	(Mohan Pallaka's message of "Fri, 13 May 2011 18:13:21 +0530")
Message-ID: <8yad3jmk1on.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13 2011, Mohan Pallaka wrote:

> For chip drivers that support both pwm and non-pwm modes
> would encounter compilation errors if the platform doesn't
> have support for pwm though the chip is programmed to work
> in non-pwm mode. Add __weak attributed pwm functions to avoid
> compilation issues in these scenarios.
>
> Change-Id: Ia507bf659d4d67d71f135012e7d919aca6c45c6c

Make sure you remove these 'Change-Id' lines before sending patches.
They aren't supposed to be in the kernel since they refer to an internal
server, and aren't useful to anyone else.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
