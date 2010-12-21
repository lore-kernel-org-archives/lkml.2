Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab0LUNqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:46:50 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23801 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0LUNqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:46:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67504726"
Message-ID: <ccc3842ee0be7b1036143d1fccd005a0.squirrel@www.codeaurora.org>
Date: Tue, 21 Dec 2010 05:46:34 -0800 (PST)
Subject: Re: [RFC/PATCH v2] usb: Add streams support to epautoconf.
From: merez@codeaurora.org
To: "Greg KH" <gregkh@suse.de>
Cc: merez@codeaurora.org, "Greg KH" <greg@kroah.com>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 20, 2010 at 11:58AM, Greg KH wrote:
> Ok, but please note the word of "proprietary" usually means something 
else when talking about kernel code (i.e. licensing issues.)
>
> I'll be glad to take this type of patch when you also provide a patch
that uses the callback, but not before then.

What I meant by "proprietary" is not proprietary in the terms of kernel
world. I meant a unique algorithm, different from the default. Sorry for
the misunderstanding.
Currently we don't have a unique algorithm. When implementing this change
we thought it may be useful for other controllers but for us the default
implementation was good enough.
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum






