Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab0FROMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:12:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42201 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab0FROL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ip6q82ccQjUVSby/Vi93c1i7eytxngan3IKZ5w+yt5sW+VhCSl1H22FxwDillB3AU9
         sTepa+TI8vCKX/yEywlTXUQHEFpHudxMyluz3v9qXqPfGeeI7ARhIL19FnJELBRdeXdO
         v/oUly1DfkY2GQ0wC7ZLusXvr7ZtS8viiXqzE=
Subject: Re: [PATCH] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1276806785.20754.8.camel@maxim-laptop>
	 <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	 <1276856142.9114.1.camel@maxim-laptop>
	 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	 <1276859156.19554.2.camel@maxim-laptop>
	 <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 17:11:49 +0300
Message-ID: <1276870309.23783.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 09:59 -0400, Bob Copeland wrote: 
> On Fri, Jun 18, 2010 at 7:05 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> Patch I made uses GPL code from e1000e, but since ath5k is
> >> dual-licensed so patch can't be accepted. So if I got it right, patch
> >> has to be remade from scratch by someone who really knows about pci
> >> registers etc. I don't, and learning this to fix something that is
> >> already fixed in my point of view is waste of (my) time.
> > Sure, regardless of licensing, this patch has to be redone (and e1000
> > with it)
> 
> At any rate, Jussi, thanks a bundle for tracking it down.  I owe you a
> beer, lots of bugs have been reported on these devices.
> 
> Maxim, this device was always broken in the same way, right?  Just
> curious if anything made it worse recently.

Always was broken, of course even with madwifi.

Recently I think driver stopped doing reset on RXORN, which sometimes
helped. This did made things a bit worse.

Anyway, just disable L0S, and card works perfectly.

Best regards,
Maxim Levitsky

