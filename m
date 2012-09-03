Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2ICJYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:24:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab2ICJYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:24:22 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Alexander <alexander@dce.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: file Documentation/usb/usbmon.txt should list the .config settings
Date: Mon, 03 Sep 2012 11:23:04 +0200
Message-ID: <4905024.kP3GZmCRKy@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc2-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50446CA1.7040904@dce.bg>
References: <50446CA1.7040904@dce.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2012 11:38:57 Alexander wrote:
> Please indicate in the Documentation/usb/usbmon.txt file that the kernel 
> needs to be compiled with:
> 
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_FS=y
> CONFIG_USB_MON=y
> CONFIG_USB_DEVICEFS=y

Are you saying tht the modular options have been broken?

	Regards
		Oliver

