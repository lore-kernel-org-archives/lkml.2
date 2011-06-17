Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab1FQP5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:57:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57464 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1FQP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=PXw2e5D3rjWaxEv+/yN/BIqtdIQJJRoYXtxJP7W5zIGG0H30ZAIEv3/RPK5HoAugl6
         xVgJ/fRM1NTU994oM6UFQW+FlqTxilhof/w0jzceC80GK2VT00OWiXSvwu0Tmg4KsL3f
         Vx/vgMgJnq7b7kR3qcHXBtv5OPKEqtqfw+Vt0=
MIME-Version: 1.0
In-Reply-To: <1308310831-27861-1-git-send-email-lars@metafoo.de>
References: <20110617103218.GA29723@opensource.wolfsonmicro.com> <1308310831-27861-1-git-send-email-lars@metafoo.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 17 Jun 2011 11:56:54 -0400
X-Google-Sender-Auth: dQekrtam9LxTX0YV1C0SwIi9kjU
Message-ID: <BANLkTi=heLis-oj2McUHi0dvtDVedZ9Yjw@mail.gmail.com>
Subject: Re: [PATCH] firmware: Make firmware drivers generally available
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 07:40, Lars-Peter Clausen wrote:
> Currently only x86, ia64 and blackfin architectures include
> drivers/firmware/Kconfig, as a result firmware drivers are only available on
> these platforms. This has not been a problem historically, because all of the
> firmware drivers were architecture specific.
>
> But this has changed with the addition of the SigmaStudio firmware loader
> (commit e359dc24 "sigma-firmware: loader for Analog Devices' SigmaStudio"),
> which is used to parse and load firmware files for Analog Devices' SigmaDSP
> processors. These DSPs are usually embedded in for example audio codecs, which
> use the I2C or SPI bus for communication and are not architecture specific.
> Thus make the firmware drivers generally available, so it can be used on all
> architectures.
>
> Note that this moves the Kconfig "Firmware Drivers" entry from the top-level to
> the "Device Drivers" submenu for architectures which had it already available.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
