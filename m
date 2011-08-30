Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1H3OPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:15:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50310 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1H3OPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:15:13 -0400
Date: Tue, 30 Aug 2011 17:12:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Youquan Song <youquan.song@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>, devel@linuxdriverproject.org,
        Joe Perches <joe@perches.com>, Ilya Gorskin <Revent82@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [PATCH v3 10/18] Staging: cx25821: Fix long lines in
 cx25821-audio-upstream.c
Message-ID: <20110830141250.GM3705@shale.localdomain>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
 <1314677833-4689-11-git-send-email-leonidsbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314677833-4689-11-git-send-email-leonidsbox@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 12:17:05PM +0800, Leonid V. Fedorenchik wrote:
> @@ -603,7 +599,8 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
>  	if (!dev)
>  		return -1;
>  
> -	sram_ch = dev->channels[dev->_audio_upstream_channel_select].sram_channels;
> +	sram_ch = dev->channels[dev->_audio_upstream_channel_select].
> +			sram_channels;

$ echo -n "_audio_upstream_channel_select" | wc -c 
30

I think I may have found the problem.  (Don't use variable names that
are a 30 zillion chars long).

regards,
dan carpenter

