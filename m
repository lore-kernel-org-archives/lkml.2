Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0IEUDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 16:03:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61779 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0IEUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 16:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=abUQVaiQHwYNUIKCZiIksxB9PKOXXnBL12rC8wmDFpbewUHVPGdNdDvU9uR5OHdhvA
         gmZT3ngD2PU8b0+R8pimmNvU/01hSKa9Iuks+lq8zvb7SWdvHjHmixAMUXIePuqAm3eq
         7EJ/Do2P6NLgWG4ZfcFlGcF+nIPpYkJjwWe1o=
Date: Sun, 5 Sep 2010 13:03:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] input: wacom: Add support for the Bamboo Touch
 trackpad (rev4)
Message-ID: <20100905200327.GB18411@core.coreip.homeip.net>
References: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
 <1283607783-29388-5-git-send-email-rydberg@euromail.se>
 <4C836B10.4040407@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C836B10.4040407@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 12:04:00PM +0200, Henrik Rydberg wrote:
> On 09/04/2010 03:43 PM, Henrik Rydberg wrote:
> 
> [...]
> 
> >@@ -955,6 +1007,12 @@ void wacom_setup_device_quirks(struct wacom
> > 	if (features->type == TABLETPC || features->type == TABLETPC2FG ||
> > 	    features->type == BAMBOO_PT)
> > 		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
> >+
> >+	/* quirks for bamboo touch */
> >+	if (features->type == BAMBOO_PT) {
> 
> This line should have "&& features->device_type == BTN_TOOL_TRIPLETAP" appended
> to it, to only target the touch device of Pen & Touch.
> 

Adjusted and applied all 5 patches. I also pulled trkid into wacom_wac
structure to make sure different instances of the device are independent
of each other.

Thanks.

-- 
Dmitry
