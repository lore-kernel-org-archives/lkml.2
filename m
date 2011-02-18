Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1BRSqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:46:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20714 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1BRSqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:46:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6261"; a="75305978"
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
From: Daniel Walker <dwalker@codeaurora.org>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        davidb@codeaurora.org, dima@android.com, tsoni@codeaurora.org,
        linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <4D5DC289.1090004@codeaurora.org>
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
	 <1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
	 <4D5DC289.1090004@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 10:46:11 -0800
Message-ID: <1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 16:51 -0800, Bryan Huntsman wrote:
> On 02/17/2011 04:37 PM, Daniel Walker wrote:
> > Can you put this in drivers/ this doesn't looks like it need to be here.
> 
> Where would you suggest?  The initial attempt to model SSBI as an I2C
> bus didn't go anywhere.  See http://lkml.org/lkml/2010/7/21/400.  This
> functionality is specific to MSM.  Plus, we're trying to maintain
> similarity to the Android MSM tree.  That may not matter to people who
> don't use MSM, but is matters to us.  Given these considerations, the
> current location seems as good a place as any.

I don't know the driver well enough to be more detailed than suggesting
drivers/ . In the thread you quoted Pavel (who I added to the CC line)
suggested drivers/ssbi/ .

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

