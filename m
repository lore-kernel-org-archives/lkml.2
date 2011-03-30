Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab1C3Ek3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 00:40:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4351 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1C3Ek2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 00:40:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6300"; a="82650489"
Message-ID: <4D92B43B.5050101@codeaurora.org>
Date: Tue, 29 Mar 2011 21:40:27 -0700
From: Jeff Ohlstein <johlstei@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] msm: watchdog: support watchdog on 8x60 and 8960
References: <1301105894-22835-1-git-send-email-johlstei@codeaurora.org> <1301426560.4049.0.camel@m0nster>
In-Reply-To: <1301426560.4049.0.camel@m0nster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> Are you saying this is mostly a debugging facility ? The interrupts off
> thing I can see as just debugging, but I don't understand the bus
> lockups part.
>   

It isn't just a debugging facility. It is still beneficial to the end user
in that it restarts the system if there is a bus lockup or a faulty 
interrupt
handler in a rarely used codepath. This is better than the alternative 
of draining
the battery and turning off. We want this to be turned on independent of 
what userspace
one is using, unless they explicitly turn it off themselves.

Jeff

--- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

