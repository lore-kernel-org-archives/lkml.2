Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1AaPLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:11:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34519 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1AaPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:11:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6242"; a="72438045"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1296133918-31099-1-git-send-email-tlinder@codeaurora.org> <Pine.LNX.4.44L0.1101271116470.2090-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101271116470.2090-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v7 1/5] usb: Adding SuperSpeed support to dummy_hcd
Date: Mon, 31 Jan 2011 17:09:32 +0200
Message-ID: <000301cbc158$df3bc470$9db34d50$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: en-us
Thread-index: Acu+PxveVr2G6Bd6RqGvhJZZNRHUigDGVeEQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch adds SS support to the dummy hcd module. It may be used to
> test
> > SS device when no (SS) HW is available.
> > USB 3.0 hub includes 2 hubs - HS and SS ones.
> > This patch adds support for a SS hub in the dummy_hcd module. Thus,
> when
> > dummy_hcd enabled it will register 2 root hubs (SS and HS).
> 
> Getting there.  A few spots could still use some attention.
> 

Could you please elaborate? 

> Also, you might try running this patch through checkpatch.pl and fixing
> any complaints it makes.
>

Actually I always do that. It came out clean. If you see something wrong
with the coding style please let me know.
 
Thank you for your input

Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




