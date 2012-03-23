Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2CWCJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:09:18 -0400
Received: from pasky.or.cz ([84.242.80.195]:33285 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2CWCJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:09:17 -0400
Date: Fri, 23 Mar 2012 03:09:13 +0100
From: Petr Baudis <pasky@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jonathan Nieder <jrnieder@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: hda-intel: azx_get_response timeout, switching to polling mode:
 last cmd=0x01db0000
Message-ID: <20120323020913.GB3554@machine.or.cz>
References: <20111229025953.15211.24880.reportbug@machine.or.cz>
 <20111229062105.GB28780@elie.Belkin>
 <20120121091602.GF30898@machine.or.cz>
 <s5hhazm6alb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhazm6alb.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi!

> At Sat, 21 Jan 2012 10:16:02 +0100, Petr Baudis wrote:
> > I will try the then-current kernel and for-next branch then.

  FYI, this issue has most likely reached a happy end. While 3.2.x
did not work properly, tonight I finally could reboot the machine
with tiwai's for-next branch and cannot reproduce the issue so far!

  I'm not sure if this is thanks to an unrelated change in interrupt
handling that got pulled around or something that's actually brewing
in the for-next branch but hopefully it will eventually find its way
to the distribution kernels.  :-)

  Thanks,

				Petr "Pasky" Baudis
