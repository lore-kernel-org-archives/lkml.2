Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab1CaTXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:23:39 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:56924 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753685Ab1CaTXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:23:37 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 15:23:37 EDT
From: Ping Cheng <pingc@wacom.com>
To: Manoj <manoj.iyer@canonical.com>, Chris Bagwell <chris@cnpbagwell.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] add support for Lenovo tablet ID (0xE6)
Date: Thu, 31 Mar 2011 19:17:35 +0000
Message-ID: <C6AE45FA1D5BD74994491BCF5D47EED9039C3A@Exchange1.wacom.com>
References: <1301592052-4064-1-git-send-email-manoj.iyer@canonical.com>
	<1301592052-4064-2-git-send-email-manoj.iyer@canonical.com>
	<20110331174334.GA414@core.coreip.homeip.net>
	<AANLkTi=a1eZS2fjxKYzf1RsE=6n9wZwUTPs8v84zb6p_@mail.gmail.com>
	<20110331180632.GB414@core.coreip.homeip.net>
 <AANLkTinB6GnF4gsX=-hXSLy9M1pUG1Y4W-sD_=4jdODi@mail.gmail.com>
 <4D94C7B3.4040307@canonical.com>
In-Reply-To: <4D94C7B3.4040307@canonical.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ping Cheng <pingc@wacom.com>.

Yes, please use E3 resolutions. The X and Y values should be from your tablet though.

Thank you.

Ping

-----Original Message-----
From: Manoj [mailto:manoj.iyer@canonical.com] 
Sent: Thursday, March 31, 2011 11:28 AM
To: Chris Bagwell
Cc: Dmitry Torokhov; linux-kernel@vger.kernel.org; Ping Cheng
Subject: Re: [PATCH] add support for Lenovo tablet ID (0xE6)


> Ah, yes.  There it is.
>
> The for-linus and next branches are quite different in this area of 
> file.  The patch of this email would not apply cleanly to for-linus.
>
> My suggestion is to use value of 0xE3 for which ever branch this is 
> merged to... but best for Ping to ack.

Chris,

Just to confirm, so base the patch on the for-linus tree and use the values as in 0xE3? is that correct? I will put Ping to ack as well.

>
> Chris
>
