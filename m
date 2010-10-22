Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab0JVUs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:48:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55220 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0JVUsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pB51ILdRv+/8dZARH6YpqAMxNu97v565J3VSAnkP8WeLektInQPTx0SKz6epY/gkRA
         xRqXWbmDl2uxJzobODGm/igdwXvLInTTHdIzXZxA3yATm7cP8yqTjmakk1mhvSj4oVi7
         rxtaEgvlODUdMvyVQzabp8VWr1AT6RTVMEl44=
MIME-Version: 1.0
In-Reply-To: <AANLkTinYtY0=Se2Kh1+3Xr71GXZmMaeMHFfo2xF6OC=F@mail.gmail.com>
References: <4CC1D2D5.9050009@gmail.com> <4CC1D6D0.8040108@gmail.com>
 <AANLkTik_rR9BESQYfMa7qdZH7MFquPnq152r7kyAU54y@mail.gmail.com> <AANLkTinYtY0=Se2Kh1+3Xr71GXZmMaeMHFfo2xF6OC=F@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 22 Oct 2010 16:48:33 -0400
Message-ID: <AANLkTikONRDi6VgxVWHM+MLvjfTQ4QsRwGJ3fNEoH+jC@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/8] Removal of dead code from arch/blackfin/include/asm/irqflags.h
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: linux-kernel@vger.kernel.org, Li Yi <yi.li@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 16:39, Zimny Lech wrote:
> 2010/10/22 Mike Frysinger:
>> NAK ... this is for xenomai
>
> Ok, thanks for your comment.
>
> BTW. I can not find *IPIPE_TRACE* is it automatically generated somewhere?

negative.  we're just friendly with the xenomai peeps.
-mike
