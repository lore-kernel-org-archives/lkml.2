Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1K3N7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:59:48 -0500
Received: from out.selfhost.de ([82.98.82.95]:58159 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755744Ab1K3N7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:59:47 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Nov 2011 08:59:46 EST
Message-ID: <4ED6353D.7010605@afaics.de>
Date: Wed, 30 Nov 2011 14:53:01 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.1.4 nags about my usb3 hardware
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

I get tons of entries in /var/log/messages, until I
disconnect my usb3 sata adapter:

:
Nov 30 14:45:31 cecil kernel: [15500.940735] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
Nov 30 14:45:33 cecil kernel: [15502.935076] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
Nov 30 14:45:33 cecil kernel: [15502.935564] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
Nov 30 14:45:33 cecil kernel: [15502.936022] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
Nov 30 14:45:35 cecil kernel: [15504.928201] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
Nov 30 14:45:35 cecil kernel: [15504.928697] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
Nov 30 14:45:35 cecil kernel: [15504.929256] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
:

CONFIG_USB_XHCI_HCD_DEBUGGING is not set, so I wonder if there
is any way to turn off these messages?

Any helpful comment would be highly appreciated.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7WNT0ACgkQUTlbRTxpHjcEpQCeMPzLeCY813P9T0dlMAONCeUz
tyoAnRpzMRiEaYr4SfYHwj6u3uL+JLuA
=07Cc
-----END PGP SIGNATURE-----
