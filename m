Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2KPTrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:47:52 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:51968 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab2KPTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:47:51 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnSpAGaXplBV5h1yPGdsb2JhbABEhVcBhQC3BwOBAxkBAQEBHwIXDSeCHgEBBAE6HCMFCwgDRhQlChoTGYduCr58FIxvg1xhA5V7hXuDTolr
X-IronPort-AV: E=Sophos;i="4.83,266,1352070000"; 
   d="scan'208";a="450891110"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 16 Nov 2012 20:54:33 +0100
To: Alexandra Chin <Alexandra.Chin@tw.synaptics.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH v6] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121116195433.GA573@polaris.bitmath.org>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121116163146.f4b53f6965ee08ca1a1fc96c@tw.synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116163146.f4b53f6965ee08ca1a1fc96c@tw.synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

> Convert to MT-B because Synaptics touch devices are capable
> of tracking identifiable fingers.
> 
> Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>

For next time: Once you have received an acked-by or reviewed-by, you
may add that line under your own signed-off-by in subsequent
mails. That way, the status of the patch can be tracked properly,
making life easier for everyone.

Greg, I think we are ready now. :-)

Thanks,
Henrik
