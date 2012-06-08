Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412Ab2FHSL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:11:58 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50952 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2FHSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:11:56 -0400
Date: Fri, 8 Jun 2012 20:11:54 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        zonque@gmail.com, tiwai@suse.de
Subject: Re: [Bisected] ALSA: snd-usb: New streaming logic causes distortions
 on Burr-Brown DAC
Message-ID: <20120608181154.GA267@x4>
References: <20120608164004.GA580@x4>
 <20120608175043.GA5109@cucamonga.audible.transient.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608175043.GA5109@cucamonga.audible.transient.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.06.08 at 17:50 +0000, Jamie Heilman wrote:
> Markus Trippelsdorf wrote:
> > I hear distortions on my Burr-Brown USB DAC whenever the (software)
> > volume is set to some value lower than 100% in mpd. The lower the volume
> > the bigger are the resulting distortions.
> 
> see patch: http://marc.info/?l=linux-kernel&m=133905533312625&w=2
> 
> You're probably getting distortion because mpd decided it would use
> a stream format that's only 8bit.

Yes. The patch fixes the issue. Many thanks.

-- 
Markus
