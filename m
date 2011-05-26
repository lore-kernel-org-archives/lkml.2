Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab1EZVPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:15:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48093 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1EZVPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KBm0g6PvRjCSnybIqzQ1YvoWOridRICD8ZqESxfcwhZJyljYixlorINRfzr9kztNBs
         pVdwFctz8pyYzSdUXam9J8mVa8G+wj2UyiOPGclEgguJ9qNILBEudyd4vSv3tWdfwJwQ
         oZhR2iC+UkNoo/yIIZVAAvXdcejN99zyJxK+4=
MIME-Version: 1.0
In-Reply-To: <20110526120702.fac24de0.randy.dunlap@oracle.com>
References: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
	<20110526120702.fac24de0.randy.dunlap@oracle.com>
Date: Thu, 26 May 2011 23:15:34 +0200
Message-ID: <BANLkTikik8+f1D4D_Dv_rFK=QQjdce9rwg@mail.gmail.com>
Subject: Re: linux-next: Tree for May 26 (drivers/net/caif)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, balbi@ti.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

[Randy]
> (not new)
>
> drivers/net/caif/caif_serial.c:194: warning: 'return' with no value, in function returning non-void
> drivers/net/caif/caif_serial.c:202: warning: 'return' with no value, in function returning non-void
>
>
> I'm curious:  how do warnings like this get overlooked?
> too much noise in the build messages?  or it wasn't overlooked, just ignored?

The patch introducing this problem is "tty: make receive_buf()
return the amout of bytes received" by Felipe Balbi <balbi@ti.com>.
It seems that this patch has been posted to linux-serial and not to
the netdev list or the gits net-next-2.6 or net-2.6 that I follow.
It's probably no excuse, but this problem is news to me.

Should I post a patch on linux-next anyway for this issue?

Regards,
Sjur
