Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab0HPTgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:36:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63222 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab0HPTf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NVHcgSmiungchwRNyUNBLTjSUepdtW+wH6mOeM5YhXM56h67AIjbb5LxOLmd6SCpLH
         UfJ4QDsaZy/45BaF/pacjw5oW+zB8/Dpoz5xcQDpc2f3MQ/1XgfB236Tbe2XP2ctS5UU
         mJ3o2a+3IPinIuKjhEDy1zQ1F5QSZSJlEit1g=
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1281986177.1926.1858.camel@laptop>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	 <1281979893.2524.54.camel@edumazet-laptop>
	 <1281981301.3268.110.camel@gandalf.stny.rr.com>
	 <1281982566.3268.137.camel@gandalf.stny.rr.com>
	 <1281983814.1926.1763.camel@laptop>
	 <1281984528.2487.25.camel@edumazet-laptop>
	 <1281986177.1926.1858.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 21:35:52 +0200
Message-ID: <1281987352.2487.40.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 août 2010 à 21:16 +0200, Peter Zijlstra a écrit :

> Adding lockdep_off() is just plain wrong, if you cannot describe the
> locking there's a fair chance its wrong anyway.
> 

I see.

I described the fine locking after Steven comment, adding a long
Changelog.

http://patchwork.ozlabs.org/patch/61827/

If someone thinks this locking is buggy, please speak now ;)



