Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1I0Gwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:52:42 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:53854 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1I0Gwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:52:41 -0400
Message-ID: <4E8172CB.8040509@ladisch.de>
Date: Tue, 27 Sep 2011 08:52:59 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: balbi@ti.com
CC: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] sound: usb: mixer: increase control transfer timeout
References: <1314616226-15942-1-git-send-email-balbi@ti.com> <s5hehzht34k.wl%tiwai@suse.de> <20110926084935.GJ3391@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110926084935.GJ3391@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgtdXNiQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> On Fri, Sep 16, 2011 at 08:25:47AM +0200, Takashi Iwai wrote:
> > Felipe Balbi wrote:
> > > 100ms might not be enough for slower devices. Increasing
> > > timeout to 1000ms doesn't seem like overkill.
> > > 
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > 
> > Felipe, what is the status of this patch?
> > Could you resend a revised patch?
> 
> Someone else can take care of it. It was supposed to be a very simple
> patch and became something larger which I don't have enough time to
> handle right now.

Done:
http://git.alsa-project.org/?p=alsa-kernel.git;a=commit;h=14d1242f90e0


Regards,
Clemens
