Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1KUPjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:39:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41958 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab1KUPjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:39:52 -0500
Date: Mon, 21 Nov 2011 16:39:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: anish kumar <anish198519851985@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: Firmware during bootup
Message-ID: <20111121153947.GA8102@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	anish kumar <anish198519851985@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	alsa-devel@alsa-project.org
References: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74C1E@HQMAIL01.nvidia.com>
 <20111118120352.GZ19069@tbergstrom-lnx.Nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74E63@HQMAIL01.nvidia.com>
 <20111121122212.GL19069@tbergstrom-lnx.Nvidia.com>
 <1321889298.1760.8.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321889298.1760.8.camel@anish-Inspiron-N5050>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:28:18AM +0900, anish kumar wrote:
> Hello Everyone,
> 
> I have a hardware(Noise processing chip) for which I am 
> writing the driver.Is it a good idea to download the 
> firmware in probe function by spawing kthread?I can't download
> the firmware using request_firmware api as this hardware
> is required during bootup for boot-up sound and request_firmware
> is out of question because of no support in user-space.
> 
> Am i missing something?I am bit concerned about boot-up time
> as well.

You could build it into the kernel, see CONFIG_EXTRA_FIRMWARE Kconfig
help for this.

-- 
Regards/Gruss,
   Boris
