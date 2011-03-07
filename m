Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1CGKhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:37:08 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60490 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1CGKhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:37:06 -0500
Subject: Re: [PATCH v2] intel8x0m: wait a bit before warm reset check
From: Paul Bolle <pebolle@tiscali.nl>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jesper Juhl <jj@chaosbits.net>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Mon, 07 Mar 2011 11:36:34 +0100
In-Reply-To: <s5hei6jgsq9.wl%tiwai@suse.de>
References: <1299366106.2470.5.camel@t41.thuisdomein>
	 <alpine.LNX.2.00.1103060105550.6297@swampdragon.chaosbits.net>
	 <s5hei6jgsq9.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.90 (2.91.90-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1299494225.2470.21.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 10:55 +0100, Takashi Iwai wrote:
> Also, as mentioned earlier, it's better to use usleep_range() than
> udelay().  There is no hard upper-limit in this case, and any longer
> sleep works.

So something like, say, usleep_range(500, 1000) should be OK?


Paul

