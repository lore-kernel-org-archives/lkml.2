Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1KWTdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:33:43 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38489 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1KWTdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:33:42 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
Date: Wed, 23 Nov 2011 20:34:24 +0100
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc9-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Havard Skinnemoen <hskinnemoen@google.com>, Jiri Slaby <jslaby@suse.cz>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com> <1322074412-10873-1-git-send-email-hskinnemoen@google.com> <20111123192233.44f512b7@bob.linux.org.uk>
In-Reply-To: <20111123192233.44f512b7@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111232034.24280.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 23. November 2011, 20:22:33 schrieb Alan Cox:
> and on the open side they provide their own install() method which
> nicely avoids all the nasty locking problems and lets them use the
> standard tty_port_open/close/hangup etc rather than the partial ones.
> 
> It might be worth turning the ACM driver to work the same way as it'll
> save doing that work later to achieve the same use of
> tty_port_open/close/..
> 
> The main thing is the use of install - which lets you plug the USB and
> tty bits together during the lookup of the device.

Which driver is the best example?

	Regards
		Oliver

