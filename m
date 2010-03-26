Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0CZOUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:20:17 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33866 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab0CZOUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HUmgvo/pEvLJ9BCR/8M5S82nByfn5I0Rc39GpOV0lUDfv/GgQRN6jtEekEqlbxGD6s
         8YnC+1OoY/sNU832kWZtxfH3lo/uV9fhY3GE9Ph1c3nLDkEqTGr+DNIMbTYR+VyFvKDf
         9+yXgZvSLHzfCl+R8KU8no/hZQEFP2I8oHsRY=
Subject: Re: behavior of recvmmsg() on blocking sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Brandon Black <blblack@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <a36005b51003260500v6d8b7a5av1bbba848cc8998a4@mail.gmail.com>
References: <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com>
	 <g76h4xrt5j1pw2kk3tUYAxe124vaj_firegpg@mail.gmail.com>
	 <84621a61003241635h65687366t6b28148281d529c9@mail.gmail.com>
	 <a36005b51003260500v6d8b7a5av1bbba848cc8998a4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 15:20:10 +0100
Message-ID: <1269613210.2839.75.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 mars 2010 à 05:00 -0700, Ulrich Drepper a écrit :
> On Wed, Mar 24, 2010 at 16:35, Brandon Black <blblack@gmail.com> wrote:
> > +                /* MSG_WAITFORONE turns on MSG_DONTWAIT after one packet */
> > +               if (!datagrams++ && flags & MSG_WAITFORONE)
> > +                       flags |= MSG_DONTWAIT;
> 
> There should be an extra pair of parenthesis around the & operands but
> aside from that I could imagine this to work.
> 
> Would be nice if the netdev folks would respond.


It seems fine, Brandon please submit a formal patch.

Thanks


