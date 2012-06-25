Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2FYU5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:57:37 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:39553 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2FYU5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:57:36 -0400
X-Greylist: delayed 1951 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2012 16:57:36 EDT
Message-ID: <4FE8C91E.2060406@ukfsn.org>
Date: Mon, 25 Jun 2012 21:25:02 +0100
From: Andy Furniss <andyqos@ukfsn.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120604 Firefox/13.0 SeaMonkey/2.10
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Sven Joachim <svenjoac@gmx.de>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: Bogus video resolution in Linux 3.5-rc4
References: <874npzebev.fsf@turtle.gmx.de> <s5ha9zr8k2f.wl%tiwai@suse.de> <87obo7jnmn.fsf@turtle.gmx.de> <s5ha9zr2o1a.wl%tiwai@suse.de>
In-Reply-To: <s5ha9zr2o1a.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:

>> The xrandr command shows various bogus modes.
>
> Can't these values be displayed on your monitor at all?
> If they can be displayed, they are valid modes, not really bogus.
> After all, they are values that EDID of your montor advertises as
> available ranges.

I have already commented on bogus modes when the patch first went into 
dcn, but to repeat -

HDMI TV - lots of new modes but it already advertised all the CVT that 
it supports and all the new are bogus.

DVI 120Hz 1920x1080 monitor many bogus modes as it won't display > it's 
res and won't scale up some of the new modes.

Even some of the new ones that are not "out of range" will actually end 
up setting something different and show some distortion.

Maybe gained a couple.
