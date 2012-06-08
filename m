Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267Ab2FHRvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:51:19 -0400
Received: from audible.transient.net ([216.254.12.79]:48737 "HELO
	audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750795Ab2FHRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:51:18 -0400
Date: Fri, 8 Jun 2012 17:50:43 +0000
From: Jamie Heilman <jamie@audible.transient.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        zonque@gmail.com, tiwai@suse.de
Subject: Re: [Bisected] ALSA: snd-usb: New streaming logic causes distortions
 on Burr-Brown DAC
Message-ID: <20120608175043.GA5109@cucamonga.audible.transient.net>
Mail-Followup-To: Markus Trippelsdorf <markus@trippelsdorf.de>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	zonque@gmail.com, tiwai@suse.de
References: <20120608164004.GA580@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608164004.GA580@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> I hear distortions on my Burr-Brown USB DAC whenever the (software)
> volume is set to some value lower than 100% in mpd. The lower the volume
> the bigger are the resulting distortions.

see patch: http://marc.info/?l=linux-kernel&m=133905533312625&w=2

You're probably getting distortion because mpd decided it would use
a stream format that's only 8bit.


-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
