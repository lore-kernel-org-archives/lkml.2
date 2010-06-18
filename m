Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab0FRN7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:59:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52720 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab0FRN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=P0UaTx+wtTdtsdiDvksE75KcSf+XHu9fR+M3Bggz2oHETMHBj8d1F+26MlPBcI9QEp
         XWplyks2956vRf/mDtwZV9HjA3O7VHZgJGSjvMrObrPI7dLb4An4nKBVpAV6pFOHJsxP
         QHkgf45HS5xHlLJo+HBo7PhU/b38UfB0/k9Io=
MIME-Version: 1.0
In-Reply-To: <1276859156.19554.2.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan>
	<1276806785.20754.8.camel@maxim-laptop>
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	<1276856142.9114.1.camel@maxim-laptop>
	<20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	<1276859156.19554.2.camel@maxim-laptop>
Date: Fri, 18 Jun 2010 09:59:20 -0400
X-Google-Sender-Auth: Cma1BdUmXkPdiFjVTOqUV1YFEAw
Message-ID: <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
Subject: Re: [PATCH] ath5k: disable ASPM
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 7:05 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> Patch I made uses GPL code from e1000e, but since ath5k is
>> dual-licensed so patch can't be accepted. So if I got it right, patch
>> has to be remade from scratch by someone who really knows about pci
>> registers etc. I don't, and learning this to fix something that is
>> already fixed in my point of view is waste of (my) time.
> Sure, regardless of licensing, this patch has to be redone (and e1000
> with it)

At any rate, Jussi, thanks a bundle for tracking it down.  I owe you a
beer, lots of bugs have been reported on these devices.

Maxim, this device was always broken in the same way, right?  Just
curious if anything made it worse recently.

-- 
Bob Copeland %% www.bobcopeland.com
