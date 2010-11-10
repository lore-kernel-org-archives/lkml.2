Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0KJPRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:17:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44872 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab0KJPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:17:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KBmZPq3U/A65ismHzg+ld1r3wAH9pFtcXQQF1UQNaCprmLa+/JGZ5obwMJINX9gYbS
         /emPzcCy7pxWGvSVthe2hsZ7BZN90eVSebda16PoJoUukm+8dyJ5teOWcNsOP3wwFYAn
         VWYJwzZJk34ZInOnO3k8k1AU8ZJ8tFg78trMk=
Message-ID: <4CDAB795.5080607@gmail.com>
Date: Wed, 10 Nov 2010 16:17:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Carmine IASCONE <carmine.iascone@st.com>
CC: Greg KH <gregkh@suse.de>, Matteo DAMENO <matteo.dameno@st.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mems applications <mems.applications@st.com>,
        Alan Cox <alan.cox@intel.com>
Subject: Re: [PATCH] staging: lis331dlh: add lis331dlh driver
References: <> <1289323527-5501-1-git-send-email-carmine.iascone@st.com> <20101109173540.GA20370@suse.de> <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB115@SAFEX1MAIL3.st.com>
In-Reply-To: <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB115@SAFEX1MAIL3.st.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 12:51 PM, Carmine IASCONE wrote:
> Hi Greg, Hi JS,
> Matteo and I have started to develop linux device drivers for our STMicroelectronics sensors about one year ago. Our main target is the Android platform (mobile phone or tablet pc), and for this reason the drivers are thought to be used on I2C bus. The drivers are enough stable, we have several customers that are using them, and also with the advice of these customers, we would like to make available them for all the linux community, merging them in the kernel upstream to be used in all linux supported platforms.
> The drivers have had a initial review by Alan Cox, that gives us some very precious advices to improve the style and robustness of the drivers. 
> We are newbies in patch generation and submission: we have followed the instructions in the Greg's video on you tube to create this first patch, so sorry if there is something that we missed. We thought to put the driver in staging directory, because before merging them in the main tree we would like to have a general revision, and also because in this first release we haven't managed the device interrupts yet. At the end the right position for these drivers could be drivers/input/misc.
> How do we proceed now? Do we need to generate a new patch adding the TODO file? Please advice.

Hi, well, I don't think this should go into staging at all as I think
it's clean enough to go upstream directly (but I repeat I'm no IIC
expert). So please resend to IIC people:
I2C SUBSYSTEM
M:      "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
M:      "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
L:      linux-i2c@vger.kernel.org

but before that, move that out of staging to drivers/i2c/ (or anywhere
where it make sense).

It's perfectly OK to add functionality later (IRQs).

regards,
-- 
js
