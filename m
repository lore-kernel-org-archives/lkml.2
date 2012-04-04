Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2DDTKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:10:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54244 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab2DDTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:10:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6670"; a="176608440"
Message-ID: <4F7C9C89.9080605@codeaurora.org>
Date: Thu, 05 Apr 2012 00:40:01 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: jean.pihet@newoldbits.com
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific
 macros in include/linux/power
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com> <1332173578-27422-3-git-send-email-j-pihet@ti.com>
In-Reply-To: <1332173578-27422-3-git-send-email-j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 3/19/2012 9:42 PM, jean.pihet@newoldbits.com wrote:
> From: Jean Pihet<j-pihet@ti.com>
>
> Move the driver specific macros from the smartreflex header file
> (arch/arm/mach-omap2/smartreflex.h) in a new header file
> include/linux/power/smartreflex.h.
>
> This change makes the SmartReflex implementation ready for the move
> to drivers/.

I wonder why someone would need a new directory under drivers/power 
where the code is not about introducing new and generic AVS framework
but it is all about OMAP specific code. What if tomorrow new generic
AVS framework comes from different chip vendor? I am sure this kind
of technology would be common in newer embedded chips.

---Trilok Soni

-- 
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
