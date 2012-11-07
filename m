Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2KGTv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:51:29 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:60991 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2KGTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:51:27 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak27AM66mlBV5h1yPGdsb2JhbABEhVEBhQC4GgEBexkBAQEBHxkNJ4IeAQEEATocIwULCANGFCUKGhOIBAq8ZBSNPoEugnNhA5V6hXuDT4lr
X-IronPort-AV: E=Sophos;i="4.80,732,1344204000"; 
   d="scan'208";a="445297127"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 7 Nov 2012 20:57:08 +0100
To: Alexandra Chin <Alexandra.Chin@tw.synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH v4] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121107195708.GA3754@polaris.bitmath.org>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121107134934.b37e923588f4a24af146a93b@tw.synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107134934.b37e923588f4a24af146a93b@tw.synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

> Convert to MT-B because Synaptics touch devices are capable of tracking
> identifiable fingers.
> 
> Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
> ---
> Changes from v4:
>         - Incorporated Henrik's review comments
>           *split function synpatics_rmi4_touchscreen_report
>           *split function synaptics_rmi4_i2c_query_device

Thanks for the changes. The patch looks cleaner, but also much larger,
containing many changes irrelevant to the commit message (and to what
has hitherto been reviewed). Please resend a minimum patch, there is
plenty of room for additional patches after this one. :-)

Thanks,
Henrik
