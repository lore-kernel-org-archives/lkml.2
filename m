Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1FXNll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:41:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62233 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1FXNld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:41:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 00/35]: System Firmware and SMBIOS Support
Date: Fri, 24 Jun 2011 15:40:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, lm-sensors@lm-sensors.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        rtc-linux@googlegroups.com, evel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, device-drivers-devel@blackfin.uclinux.org,
        linux-watchdog@vger.kernel.org, grant.likely@secretlab.ca,
        dz@debian.org, rpurdie@rpsys.net, eric.piel@tremplin-utc.net,
        abelay@mit.edu, johnpol@2ka.mipt.ru
References: <20110623172206.27602.34306.sendpatchset@prarit.bos.redhat.com>
In-Reply-To: <20110623172206.27602.34306.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241540.57952.arnd@arndb.de>
X-Provags-ID: V02:K0:m++6f1cIBDORg80Sabu07FqOvpJc7GfwXMvTeAQie9o
 7vxbnrDWwfH/pFlOEvl759EchM7dawCu/c1j1XHkYqWfYUTSyi
 ehSI7zar+MTVdqEe2qN5rtgy8bkPphdD6X8IoCfVYgvd4knyRI
 izcVy17logivw2O5mlXo5W0iJBpkZy1OIcqaITQGBZWtsnZGVs
 BTK5S0x31+ToicGq9CPkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 June 2011 19:22:06 Prarit Bhargava wrote:
> This new patchset reworks the existing DMI code into two separate layers.  It is
> based off of the feedback I received previously when discussing the SMBIOS
> version patch on LKML.

Hi Prarit,

No objections to the patches, but when you send out a series as long as
this one, please ensure that all patches are sent as replies to the
introductory mail. Also, do not repeat the one-line patch summary in the
body of the email.

When using "git send-email --thread --no-chain-reply", this works
automatically. It will also let you put the Cc list into the
patch description and work out where to send each patch.

	Arnd
