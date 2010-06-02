Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0FBWQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:16:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0FBWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:16:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 00/31] tty: BKL removal
Date: Thu, 3 Jun 2010 00:16:44 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006030016.44621.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/doxjdmf0J0+kL18pO0cHWEL5KIP2e+cMyJfk
 yNqo/gd8sBmuY29bS8i/H/h/FGZRYSQP8EcssSAl8C2DO7tS6U
 EyPsQOGrnT2mg4i9uZOtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010 22:52:40 Arnd Bergmann wrote:
> Hi Greg,
> 
> As promised, here is a resend of the patches from
> both Alan and myself, making the BKL optional
> in the TTY layer. Please apply to your tty-next
> tree.

FWIW, I've documented what I've learned about the BKL (now BTM)
locking in the tty code, see
http://kernelnewbies.org/BigKernelLock?action=AttachFile&do=view&target=tty_lock.png

I hope that helps in the process of killing the BTM itself.

	Arnd
