Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572Ab0HFT7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:59:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759391Ab0HFT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:59:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Date: Fri, 6 Aug 2010 21:58:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20100805213528.GA13794@kroah.com> <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk> <AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com>
In-Reply-To: <AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008062158.46013.arnd@arndb.de>
X-Provags-ID: V02:K0:J+qrxqs0iUmFbkLgt8Sd2S7Ane49HM78n9iPNQDBAxb
 pwqUdJgDsDILFP4IIjqc12jR18eLottZvsznU5HHxf3ajDW0wg
 xTv6zNAgb7ry6swNtZM4Aj30tVVF2v9cKw8xILGrRjUyd59Jgq
 +Nj5wVmwD6MYM9pQ3KkqaNEvZHc+Vq8N71VklZEYlWS1bwJe9E
 qOv9CmeV4uvNzm0tYiTiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 August 2010 21:38:36 Linus Torvalds wrote:
> I also don't want the BKL to show up in grep, even if the config
> option for it were to be impossible to enable. If we've gotten far
> enough that we can get rid of the BKL in the tty layer, we really
> should get rid of it. Not leave it in some zombie limbo state.

Ok, I've sent the replacement patch that does this, and I'm much
happier with the outcome.

If you apply this version, the only stronghold left for the BKL
will be fs/lockd, everything else that's left is either simple
to fix or highly obscure.

	Arnd
