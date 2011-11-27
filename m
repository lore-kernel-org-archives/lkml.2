Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1K0LyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:54:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42053 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1K0LyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:54:18 -0500
Date: Sun, 27 Nov 2011 11:54:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali Roh??r <pali.rohar@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with
 ioctl for reading registers
Message-ID: <20111127115416.GA2579@sirena.org.uk>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <7780165.E3DXgdWAv1@pali-elitebook>
 <20111125204626.GA25003@oksana.dev.rtsoft.ru>
 <33058541.3DK13LYaLI@pali-elitebook>
 <20111125220448.GA2078@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125220448.GA2078@oksana.dev.rtsoft.ru>
X-Cookie: Know Thy User.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 02:04:48AM +0400, Anton Vorontsov wrote:

> What would be more practical, is to allow I2C core to provide
> userspace interface even for already bound I2C devices.

> That could be some kind of CONFIG_I2C_UNSAFE_DEBUG: when
> selected I2C core would allow access to all I2C devices. But still,
> the niche for such a feature is tiny, so I doubt that it is worth
> doing at all.

I don't know if it's applicable here but if this is a device that has
registers that fit within regmap then the regmap API provides a debugfs
interface for dumping the register map as standard.
