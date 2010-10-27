Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0J0Tlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:41:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65439 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab0J0Tlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hrX31ftBaqZiA8MAysWZoMwhereQppOReEFXztozJ7vjdf1hKwIWDSbVLw/bFQ9R+W
         y/4FxRmtlk7ryNQZSGyBH9jpnEgexPdLW+N9n/UMp5kcrozkPhorGZyHIeA9X4J5ur1c
         wI/7mZ0ZPBWTp1Lwyzo6ze+l62waBh2baQ7fk=
Subject: Re: [PATCH] pktgen: Remove a dangerous debug print.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: David Miller <davem@davemloft.net>, robert.olsson@its.uu.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eugene@redhat.com
In-Reply-To: <20101027192808.GP16803@ksplice.com>
References: <1288206788-21063-1-git-send-email-nelhage@ksplice.com>
	 <20101027.122143.02260950.davem@davemloft.net>
	 <20101027192808.GP16803@ksplice.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 21:41:39 +0200
Message-ID: <1288208499.2658.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 15:28 -0400, Nelson Elhage a écrit :
> How would you feel about limiting the debug print to at most, say, 512 or 1024
> bytes? Even if it's only accessible to root by default, I don't a userspace
> program should be able to accidentally corrupt the kernel stack by writing too
> many bytes to a file in /proc.

Arent /proc writes limited to PAGE_SIZE anyway ?

On x86 at least, you cannot corrupt kernel stack, since its bigger than
PAGE_SIZE.

I agree pktgen code is a bit ugly and needs a cleanup, but who
cares ? :)




