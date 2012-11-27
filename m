Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2K0UYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:24:53 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:40660 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab2K0UYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:24:51 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjN3AEAhtVBV5qjOPGdsb2JhbABFhUAiAYUAtToXAwEBAQE4NIIeAQEFOhwjEAgDGC4UDRgKGhOHewMTr22GXw2JVBSLPWmDYGEDlCyBVIV7hTqIAQ
X-IronPort-AV: E=Sophos;i="4.83,330,1352070000"; 
   d="scan'208";a="233816050"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 27 Nov 2012 21:25:54 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] HID: hid-multitouch: creates and handle stylus
 report with dual-sensors
Message-ID: <20121127202554.GA901@polaris.bitmath.org>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
 <1353684694-5723-5-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353684694-5723-5-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 04:31:27PM +0100, Benjamin Tissoires wrote:
> Now that drivers can create new inputs, let's use this to split
> the reports coming from the pen and from the touch.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)

NAK on this one in its present form. I appreciate the idea, just not
the implementation, sorry.

Thanks,
Henrik
