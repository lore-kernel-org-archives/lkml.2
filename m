Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1AIX4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:56:11 -0500
Received: from mail.perches.com ([173.55.12.10]:3050 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab1AIX4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:56:08 -0500
Subject: Re: [PATCH 4/5] Coding style in serial2002 Patch that resolves
 braces and KERN_ warnings by checkpatch.pl Signed-off-by: Michael Ahern
From: Joe Perches <joe@perches.com>
To: ahern.michael.t@gmail.com
Cc: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1294614196-6665-4-git-send-email-ahern.michael.t@gmail.com>
References: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
	 <1294614196-6665-4-git-send-email-ahern.michael.t@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Jan 2011 15:56:05 -0800
Message-ID: <1294617365.7495.193.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 10:03 +1100, ahern.michael.t@gmail.com wrote:
> From: mah <ahern.michael.t@gmail.com>

Hi Michael, just trivia.

>  drivers/staging/comedi/drivers/serial2002.c |  206 ++++++++++++---------------
> @@ -451,23 +454,23 @@ static int serial_2002_open(struct comedi_device *dev)
>  				command = (data.value >> 8) & 0x3;
>  				switch (kind) {
>  				case 1:{
> -						cur_config = dig_in_config;
> +					cur_config = dig_in_config;
>  					}
>  					break;
>  				case 2:{

You could remove the braces from all the case labels as well.

[]

> +						switch (unit) {
> +						case 0:{
> +							min = min * 1000000;

Perhaps *= 1000000 and *= 1000


