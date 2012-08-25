Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2HYRif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:38:35 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:60864 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2HYRie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:38:34 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap5TAKwMOVBV5qoUPGdsb2JhbABFhRoiAbUtGQEBAQEeGQ0ngiABAQU6HCMQCAMYLhQlChqIJAe7TQQUinSGMWADlVSFbI0P
X-IronPort-AV: E=Sophos;i="4.77,826,1336341600"; 
   d="scan'208";a="396832099"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 25 Aug 2012 19:43:42 +0200
To: Shea Levy <shea@shealevy.com>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
Message-ID: <20120825174342.GA4057@polaris.bitmath.org>
References: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
 <50390B54.4040706@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50390B54.4040706@shealevy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 01:28:52PM -0400, Shea Levy wrote:
> Hello,
> 
> On 08/25/2012 01:28 PM, Henrik Rydberg wrote:
> >+	/* Apple-specific (Broadcom) devices */
> >+	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
> >+
> >
> 
> Would this subsume https://lkml.org/lkml/2012/8/22/689 ?

Yes, it will make 05ac:821d work as well. If you are able to test it
successfully, we can append the commit message and add your Tested-by.

Thanks,
Henrik
