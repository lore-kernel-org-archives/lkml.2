Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0LTTeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:34:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28002 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915Ab0LTTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:33:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67594639"
Message-ID: <e81cf70b35cab2396bf79c3fbc9c268b.squirrel@www.codeaurora.org>
Date: Mon, 20 Dec 2010 11:33:44 -0800 (PST)
Subject: Re: [RFC/PATCH v2] usb: Add streams support to epautoconf.
From: merez@codeaurora.org
To: "Greg KH" <greg@kroah.com>
Cc: "Maya Erez" <merez@codeaurora.org>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Dec 16, 2010 at 10:15AM, Greg KH wrote:
> What do you exactly mean by "proprietary search algorithm"?
Our implementation for finding an EP with the required number of streams
may not fit the needs and platform definitions of all controllers.  For
example, having the minimum number of streams as a parameter will allow
controllers to compromise on the number of required streams in case there
is no EP that answers their first request.
At the beginning of usb_ep_autoconfig we could see many if statements for
finding the fitting EP for several controllers (for example
gadget_is_net2280). The new gadget op will prevent having additional if
statements in the usb_ep_autoconfig in case a different search is needed. 
Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum









