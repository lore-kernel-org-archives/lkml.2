Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1EWJRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:17:09 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:46072 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1EWJRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:17:06 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnJqAHAl2k1V5qkTPGdsb2JhbACJJJx9CwEBAQE3M4hwuUEOhgsElE6KOg
X-IronPort-AV: E=Sophos;i="4.65,255,1304287200"; 
   d="scan'208";a="190622639"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 23 May 2011 11:22:07 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Support for multiple devices
Message-ID: <20110523092207.GA13665@polaris.bitmath.org>
References: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> I am still getting some reports for new multitouch devices.
> Usually, I ask people to send the logs of the device to be able
> to finely tune the kernel processing of the events.
> As of today, I've got 5 devices that needs to be tested with
> the fine tuning or that I missed the logs (ActionStar, CVTouch,
> GoodTouch, Touch International and Unitec panels).
> Instead of waiting eternally for the feedback, I thought I
> should send them for inclusion now, and we will eventually
> reduce the kernel processing for those devices later.
> All these devices show that they are Win7 compliant from
> their report descriptors (and logs for some of them), so it
> should be safe.
> 
> Finally, I saw that the class for Stantum devices was redundant
> with the one included by Ilitek, so I moved Stantum
> devices to the generic one.

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
