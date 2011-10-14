Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1JNISN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 04:18:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1JNISL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 04:18:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH] HID: usbhid: enable remote wakeup for mice
Date: Fri, 14 Oct 2011 10:18:28 +0200
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: jkosina@suse.cz, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1318578888-7599-1-git-send-email-bleung@chromium.org>
In-Reply-To: <1318578888-7599-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141018.28446.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 14. Oktober 2011, 09:54:48 schrieb Benson Leung:
> This patch enables remote wakeup by default on USB mouse
> devices. This only covers USB mice that support
> the boot protocol. See commit 3d61510f for the
> equivalent patch for USB keyboard devices.

This doesn't loo like a very good idea.
Firstly your patch introduces gratious change in the hid driver.
Secondly you are changing the usbmouse driver, which is to
be used under special circumstances only, only.
Thirdly a fundamental change like that needs a commit entry
explaining the reason for the change.

	Regards
		Oliver
