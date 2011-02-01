Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1BAMlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:41:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab1BAMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:41:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio: console: Move file back to drivers/char/
Date: Tue, 1 Feb 2011 13:40:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Greg KH <greg@kroah.com>
References: <20110131221454.GA14884@kroah.com> <bd7e7969221007e205ef0d2bf144d2f3109036da.1296532834.git.amit.shah@redhat.com>
In-Reply-To: <bd7e7969221007e205ef0d2bf144d2f3109036da.1296532834.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011340.56125.arnd@arndb.de>
X-Provags-ID: V02:K0:CGrg+omr/VviHsS8nCZJsTgYJRQOBPHW/Ume+/UuNXn
 wgfuuEdeUMTWeoHIoW50wLnRZ0+AD4a4XmznxRR0N46uwpwp22
 IBSRiu9ufjC7RxSXpda7pJRWKvqsFY+g5aoEd1n8qXHtg02JxY
 mZhk/W/MCd7gzv69LiRPGaeaau84Mudzt1jv01MC3pyoTn2LH/
 n4RvJNhdj6evplKV1ZeJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 February 2011, Amit Shah wrote:
> Commit 728674a7e466628df2aeec6d11a2ae1ef968fb67 moved virtio_console.c
> to drivers/tty/hvc/ under the perception of this being an hvc driver.
> It was such once, but these days it has generic communication
> capabilities as well, so move it to drivers/char/.
> 
> In the future, the hvc part from this file can be split off and moved
> under drivers/tty/hvc/.
> 
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Greg KH <greg@kroah.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Amit Shah <amit.shah@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
