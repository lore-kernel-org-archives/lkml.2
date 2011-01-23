Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1AWTei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 14:34:38 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62367 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1AWTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 14:34:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6235"; a="71430420"
Message-ID: <e146c388999f324ac94d72d35d4fa656.squirrel@www.codeaurora.org>
In-Reply-To: <20110120163811.GB30680@kroah.com>
References: <1295523914-20056-1-git-send-email-merez@codeaurora.org>
    <20110120163811.GB30680@kroah.com>
Date: Sun, 23 Jan 2011 11:34:19 -0800 (PST)
Subject: Re: [RFC/PATCH v4] usb: Add streams support to the gadget 
     framework.
From: merez@codeaurora.org
To: "Greg KH" <greg@kroah.com>
Cc: "Maya Erez" <merez@codeaurora.org>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, January 20, 2011 8:38 am, Greg KH wrote:
> Why?  What in-kernel code needs this?
> Again, why?
Both chnages are required for the UASP device driver
(http://marc.info/?t=129559592400001&r=1&w=2).

Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


