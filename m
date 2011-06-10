Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab1FJSOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:14:06 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34038 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab1FJSOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:14:04 -0400
Message-ID: <4DF25EAF.7050203@metafoo.de>
Date: Fri, 10 Jun 2011 20:13:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: Blackfin: Add bf5xx-adau1701 machine
 driver
References: <1307726331-28618-1-git-send-email-lars@metafoo.de> <1307726331-28618-2-git-send-email-lars@metafoo.de> <20110610173004.GJ26441@sirena.org.uk> <4DF25959.9060603@metafoo.de> <20110610180256.GQ26436@opensource.wolfsonmicro.com>
In-Reply-To: <20110610180256.GQ26436@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 08:02 PM, Mark Brown wrote:
> On Fri, Jun 10, 2011 at 07:50:17PM +0200, Lars-Peter Clausen wrote:
>> On 06/10/2011 07:30 PM, Mark Brown wrote:
> 
>>> So, I keep on complaining about the way these drivers are just generic
>>> to any random Blackfin plus CODEC combination rather than being board
>>> specific.  It'd be good if we could improve this, even adding something
>>> into the driver name to make it clear these are for the EVB would help.
> 
>> I think this is due, that the codecs them-self sit on an add-on board to the
>> bf5xx eval boards.
>> So you have two boards, the bf5xx eval board with has the codec eval board
>> connected to it. That's why it it is kept so generic. You could connect the
>> codec eval board to any of the bf5xx boards.
> 
> I'd be more happy with that if there were some indication in the code
> that this was for the standard Blackfin EVBs rather than all systems
> based on Blackfin.

I could rename the machine driver to bf5xx-adau1701-evb for v2.

- Lars
