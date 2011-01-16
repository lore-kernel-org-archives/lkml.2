Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1APRN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 12:13:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43494 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1APRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 12:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sQWaPPuvU5ZuccqQCfiaO5KD6QGQtbA4zbGrkHjdQc8Sc+wKwcg1HVMfxEPYddvptA
         7gFoHe7k1l2mKt9gT9ZRmKuWg31FywIhvSRsXL9EtJcCjzbaLnRFouF6zba7mez+JbIF
         K1vfBaLsUJi8Z5nYIKzAqkxLkyaIArJzt0P+k=
Subject: Re: Current GIT for networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: piotr@hosowicz.com
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D331D0A.7070106@example.com>
References: <4D331D0A.7070106@example.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 18:13:15 +0100
Message-ID: <1295197995.12859.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 16 janvier 2011 à 17:30 +0100, Piotr Hosowicz a écrit :
> Hello Dave, hello all,
> 
> Dave, I noticed that the following GIT resource fetches vaery quickly, 
> almost instantly. Is the location still as follows?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git master

Yep, as mentioned in MAINTAINERS :

NETWORKING [GENERAL]
M:      "David S. Miller" <davem@davemloft.net>
L:      netdev@vger.kernel.org
W:      http://www.linuxfoundation.org/en/Net
W:      http://patchwork.ozlabs.org/project/netdev/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
S:      Maintained
F:      net/
F:      include/net/
F:      include/linux/in.h
F:      include/linux/net.h
F:      include/linux/netdevice.h


