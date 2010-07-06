Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0GFRdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:33:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37272 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0GFRdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CWPni8rpKmbpD54fK6sMQ6XzXmLnxOMDNxJ3CoJP+rNS3eJhM7C4+kL0c/h55ppcmk
         QmB4pTBa8NJof6M5EZ30NscxBsNDaK+vPcKSJLeLEC30pWBfKUJNqZgEKuO2vvbPfqIb
         8UNJrkDvtxbkILEEyHpQD/Ur9HcLDEV345c20=
MIME-Version: 1.0
In-Reply-To: <1278435198.5396.73.camel@dermezel>
References: <1278435198.5396.73.camel@dermezel>
Date: Tue, 6 Jul 2010 12:25:35 -0500
Message-ID: <AANLkTingSXbyFclWga9x5aD7MoccCMqhu56PCOVTKHVJ@mail.gmail.com>
Subject: Re: [PATCH] Staging: dt3155: fix coding style issues in dt3155_drv.c
From: Aldo Cedillo <aldobrett11@gmail.com>
To: kagen101@gmail.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
> index 66db878..f6edd66 100644
> --- a/drivers/staging/dt3155/dt3155_drv.c
> +++ b/drivers/staging/dt3155/dt3155_drv.c
> @@ -308,33 +308,42 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
>  #endif
>                        if (fb->nbuffers > 2) {
>                                if (!are_empty_buffers(minor)) {
> -                                       /* The number of active + locked buffers is
> -                                        * at most 2, and since there are none empty, there
> -                                        * must be at least nbuffers-2 ready buffers.
> -                                        * This is where we 'drop frames', oldest first. */
> +                                       /* The number of active +
> +                                        * locked buffers is at most 2,
> +                                        * and since there are none empty,
> +                                        * there must be at least nbuffers-2
> +                                        * ready buffers.
> +                                        * This is where we 'drop frames',
> +                                        * oldest first. */
>                                        push_empty(pop_ready(minor),  minor);
>                                }
>

In the CodingStyle in the kernel you can read:

The preferred style for long (multi-line) comments is:

        /*
         * This is the preferred style for multi-line
         * comments in the Linux kernel source code.
         * Please use it consistently.
         *
         * Description:  A column of asterisks on the left side,
         * with beginning and ending almost-blank lines.
         */

Again I ask about the coding style because I have seen in many parts of the
kernel I've seen discrepancies with what is said in the CodingStyle file. So
I want to get it clear maybe I can help to clean those things.

Thanks,
Aldo Brett
