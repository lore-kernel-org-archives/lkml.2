Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1ABVzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 16:55:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44246 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1ABVzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 16:55:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GwAU3OF5IinE18Ro7OXHZhDSPU3cWjktmpkgmlTqvttP4nfWTIn0g1SouhW8J6r/eE
         h6G6c8UnMYn5N5GYRsPbyTwa0UixU/pe7JjOlqb3NIp/ifXGVB3UVIOr6GLr49CRz6D6
         VvWzmPlIw2NZV19/1UQ2iHi4aeP6P/Bz7Qo5Y=
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com
In-Reply-To: <1293982286-15389-1-git-send-email-stefani@seibold.net>
References: <1293982286-15389-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 22:55:29 +0100
Message-ID: <1294005329.2535.258.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 janvier 2011 à 16:31 +0100, stefani@seibold.net a écrit :
> From: Stefani Seibold <stefani@seibold.net>
> 
> Changelog:
> 31.12.2010 first proposal
> 01.01.2011 code cleanup and fixes suggest by Eric Dumazet
> 02.01.2011 kick away UDP-Lite support
>            change spin_lock_irq into spin_lock_bh
> 	   faster udpcp_release_sock
> 	   base is now linux-next

Since you depend on zlib_adler32(), you should add a dependence in
Kconfig so that its available

select ZLIB_INFLATE


