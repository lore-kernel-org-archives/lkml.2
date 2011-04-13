Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1DMOnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:43:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55651 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab1DMOno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JniZQz1jKKzJFLIt1K0IzLf6tQthT1wmprv4FyFaYdeyDFBSa4dOvDJRuh+8tV11tb
         EYD2y9dxLv2n+LEfHQoBgZYkO3uON84Ks5Bu9BK3ySDF80b/O4mBONToIEnoUEul9lJ0
         J7NzxPEHS6c+PfG6gIhRKGRRaFif1yZd2732Y=
Subject: Re: [PATCH] Clean console safely
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Petr =?UTF-8?Q?P=C3=ADsa=C5=99?= <ppisar@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1302705170-15712-2-git-send-email-ppisar@redhat.com>
References: <1302705170-15712-1-git-send-email-ppisar@redhat.com>
	 <1302705170-15712-2-git-send-email-ppisar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 17:40:51 +0300
Message-ID: <1302705651.2768.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 16:32 +0200, Petr Písař wrote:
> Traditional \E[2J sequence erases console display but scroll-back
> buffer and underlying device (frame) buffer keep data that can be
> accessed by scrolling console back.
> 
> This patch introduce new \E[J parameter 3 that allows to scramble
> scroll-back buffer explicitly. Session locking programs (screen,
> vlock) can use it to prevent attacker to browse locked console
> history.
> ---
>  drivers/tty/vt/vt.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

You forgot to "Signed-off-by:" it.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

