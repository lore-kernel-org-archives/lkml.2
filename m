Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0KEQJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:09:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42803 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab0KEQJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:09:15 -0400
Date: Fri, 5 Nov 2010 17:09:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/adt7470 crash on module load (2.6.37-rc1)
Message-ID: <20101105170907.651953d2@endymion.delvare>
In-Reply-To: <20101105161741.459be240@endymion.delvare>
References: <20101104170929.f5198be3.randy.dunlap@oracle.com>
	<20101105094222.2bfbfb92@endymion.delvare>
	<4CD4187F.1030305@oracle.com>
	<20101105161741.459be240@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010 16:17:41 +0100, Jean Delvare wrote:
> The "i2c-15" above suggests that you have at least 16 I2C adapters on
> your system. There are many such adapters in graphics cards, TV cards
> (both analog and digital) and on the mainboard as well. You can get a
> list with:
> 
> # modprobe i2c-dev
> # i2cdetect -l
> 
> But given the problem you've just reported, I expect the above command
> to crash on 2.6.37-rc1. You could try it on 2.6.36 to at least give me a
> rough idea of what I2C adapters are available on your system. This
> would help me understand what's happening.

Actually, the following command on 2.6.37-rc1 should work and answer my
question:

$ grep . /sys/bus/i2c/devices/i2c-*/name

-- 
Jean Delvare
