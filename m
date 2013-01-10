Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3AJI6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:58:32 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48386 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3AJI6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:58:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130110093255.5353fb31@endymion.delvare>
References: <1357764624-32134-1-git-send-email-laurent.navet@gmail.com>
	<20130110093255.5353fb31@endymion.delvare>
Date: Thu, 10 Jan 2013 09:52:36 +0100
Message-ID: <CAH7P7NjdKsWjttmWyKxttm=rJDAErZxe7+Zf_oaSCx6Pmc1GWw@mail.gmail.com>
Subject: Re: [PATCH] drivers: i2c-nforce2: fix coding style issues
From: Laurent Navet <laurent.navet@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

>
> Unfortunately your patch also add one new checkpatch.pl warning:
>
> WARNING: line over 80 characters
> #245: FILE: drivers/i2c/busses/i2c-nforce2.c:272:
> +		data->word = inb_p(NVIDIA_SMB_DATA) | (inb_p(NVIDIA_SMB_DATA + 1) << 8);
>
> Please fix.
>
> As mentioned previously, __devinit has been dropped meanwhile, so this
> change doesn't apply cleanly. Please rebase your patch on top of kernel
> 3.8-rc3 (or Wolfram's i2c tree) so that Wolfram can apply it.
>
> All the rest looks very good now, thanks for the good work.

I've worked and tested against git.pengutronix.de wsa/linux.git
( http://git.pengutronix.de/?p=wsa/linux.git;a=summary )
Isnt' it the right one ?


-- 
Laurent.
