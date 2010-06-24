Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0FXQCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:02:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41629 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0FXQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ro+ZBYNUuFAhyYlY+9Doe7bYLgIS83XmBHQsM2EplN/nIA4b81pG5OT0MAOKj6gC7e
         6vTF468y5opfa13JVRYtggDz1XFx51lYv6i6YP5qVAD5mBKiNHN9o2HuTKvFzwLJ2tTG
         cuTsQHBx2S6LRaJQBdX3nzPCnZKqtuLoWbPWY=
Subject: Re: [patch 01/52] kernel: add bl_list
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100624144228.GC10441@laptop>
References: <20100624030212.676457061@suse.de>
	 <20100624030725.718438579@suse.de>
	 <1277359462.3471.1156.camel@edumazet-laptop>
	 <20100624144228.GC10441@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 18:01:53 +0200
Message-ID: <1277395313.2816.606.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 juin 2010 à 00:42 +1000, Nick Piggin a écrit :

> Sure, if you have an interest in using it, it will be trivial to send
> upstream. Should we merge it before any users appear? I don't know...
> 

I'll work on using this for ip route cache, as you suggested.

BTW, I think we could care about this 0 bit only if it could possibly
set, ie :

#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)

since bit_spin_lock() wont set it anyway if CONFIG_SMP=n and
CONFIG_DEBUG_SPINLOCK=n



