Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1AZIRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:17:15 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38268 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1AZIRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:17:13 -0500
Date: Wed, 26 Jan 2011 09:17:12 +0100
From: Andreas Mohr <andi@lisas.de>
To: jamagallon@ono.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>
Subject: Re: WiFi USB key
Message-ID: <20110126081712.GA18154@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126005931.59fce843@werewolf.home>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I suppose it is because the module does not recognize the USB IDs in my
> device. How can I force it to try without recompiling kernel ?
> Is there any parameter o alias in modprobe.conf I could try ?

There are even _two_ ways for preliminary attempts at adding
a new device ID to USB drivers:

quote
"You can echo the vendor and device id to the "new_id" file in the
/sys/bus/usb-serial/drivers/cp2102/ directory."

And at least for the ftdi_sio driver (and perhaps some others),
there's the product/vendor module parameter (see modinfo ftdi_sio).


http://www.ha19.no/usb/


Thanks for the report!
(and please notify or even write a patch in case the driver actually
supports the device, and does so sufficiently successfully)

Andreas Mohr
