Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab1FFU4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:56:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35799 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab1FFU4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sDPjP2LyKQwezrZcinA/RR8S42BaHHB10Fbx69wX9MxpBMQrZt1vJ5f3PlbbBwUCXJ
         Tq9Ebbo6n6/0OfvXVpkt4/mVtqRV9nhhW+1GXyz+0V3Q+QzQZeRQzXYmUGnj0ggzdo87
         q77cJa/cV3fKiS6iH5youM1+Lo2RBYy9eCOxE=
Subject: Re: [PATCH 2/3] atomic: move atomic_add_unless to generic code
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@osdl.org>, Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <1307381251-15729-2-git-send-email-asharma@fb.com>
References: <1307381251-15729-1-git-send-email-asharma@fb.com>
	 <1307381251-15729-2-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 22:56:33 +0200
Message-ID: <1307393793.2642.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 10:27 -0700, Arun Sharma a écrit :
> This is in preparation for more generic atomic
> primitives based on __atomic_add_unless.
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: David Miller <davem@davemloft.net>
> Cc: Andrew Morton <akpm@osdl.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> LKML-Reference: <20110531105019.GF24172@elte.hu>

Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>


