Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1ANJR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:17:28 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:43547 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab1ANJRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:17:19 -0500
Message-ID: <4D301495.3050906@free.fr>
Date: Fri, 14 Jan 2011 10:17:09 +0100
From: Julien Boibessot <julien.boibessot@free.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Sascha Hauer <s.hauer@pengutronix.de>, liu.y.victor@gmail.com,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, B02280@freescale.com
Subject: Re: [PATCH v2] i.MX51 Framebuffer support
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de> <4D246C54.9060503@free.fr> <20110106094237.GB31708@n2100.arm.linux.org.uk>
In-Reply-To: <20110106094237.GB31708@n2100.arm.linux.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux a écrit :
> On Wed, Jan 05, 2011 at 02:04:20PM +0100, Julien Boibessot wrote:
>   
>> The only strange thing I noticed was a kind of uggly sprite/artefact
>> (32x32, I would say) appearing at the same time as the Linux console. I
>> think it may be related to a hardware cursor badly (?) initialised, but
>> I didn't find a fix yet.
>> It disappears when I launch a graphical application (Qt or SDL).
>>     
>
> In the top left corner?  That'll be the linux penguin logo, and if it's
> not coming out correctly, your framebuffer driver is badly broken.
> Maybe your RGB bitfield information or visual is wrong?
>   
Sorry for my late answer...
Penguin logo is OK, the artefact is just under the penguin and is
looking like a blinking cursor until login message is displayed. At that
time it becomes a kind of uggly rectangular black and white lines mix,
overlapping logging message.
I will follow Sascha's advise and try to play with i.MX51 hardware cursor.

Regards,
Julien
