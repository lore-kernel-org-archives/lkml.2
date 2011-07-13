Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1GMM5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:57:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1GMM5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:57:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/2] TTY: remove tty_locked
Date: Wed, 13 Jul 2011 14:56:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
References: <201107122325.35013.arnd@arndb.de> <1310553086-27427-1-git-send-email-jslaby@suse.cz> <1310553086-27427-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1310553086-27427-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107131456.47298.arnd@arndb.de>
X-Provags-ID: V02:K0:Ny6AYxKNQopdc0TbyE7uRQ4yesyqDljGqCJgvcrzQCo
 A/4VCKpJ+RSjMB2IRPCRORseukZ4U3RkjIdZFD4whMPnM/5iqH
 dN3Fg19rxmh7fMRtbP7C/iLGe/GhGQCWAyKkcZDT6D6Sea3LEn
 IW3ez3q4A2CWMJbIdBjZckQ7u0q0F3QY3gwgL8ZXXygFxQ9g4W
 6KZ4ErmRTfh3Irq84lNNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 July 2011, Jiri Slaby wrote:
> We used it really only serial and ami_serial. The rest of the
> callsites were BUG/WARN_ONs to check if BTM is held. Now that we
> pruned tty_locked from both of the real users, we can get rid of
> tty_lock along with __big_tty_mutex_owner.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
