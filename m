Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1EZF4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:56:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56547 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab1EZF4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M0UD/OfQEYc6HPY6KKWjhNtz/RSfwiFA0ih4GN+gVGfWMG81V0PTHgnExfosI7QlFx
         SgUy1r68MfZc/sDhEuv+Nsd022Ge6oeVYaVRH+4UcJV4zT4LFVUM419elf76GxoloSq9
         U6zvV6NpDwJhGyRuV0HL2x7z+niD93+qfpguE=
Subject: Re: [GIT PULL] Core block bits for 2.6.40
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tao Ma <boyu.mt@taobao.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1306388153.2664.4.camel@edumazet-laptop>
References: <4DDCFE21.80003@fusionio.com>
	 <1306388153.2664.4.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 07:56:44 +0200
Message-ID: <1306389404.2664.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 mai 2011 à 07:35 +0200, Eric Dumazet a écrit :

> At boot, I have a crash in part_discard_alignment_show+0x1b/0x50
> 
> CR2 : 000006ac
> 
> fault in : mov    0x2c(%rcx),%edx
> 
> I suspect commit 23ceb5b7719e9276d4 (block: Remove extra
> discard_alignment from hd_struct) being in fault

I confirm 'kind of revert patch' makes my machine happy again.

disk->queue can probably be NULL



