Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab0HFIj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:39:28 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59477 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0HFIjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:39:25 -0400
Date: Fri, 6 Aug 2010 16:39:00 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Olivier Galibert <galibert@pobox.com>
Cc: kyle@moffetthome.net, torvalds@linux-foundation.org,
        herbert@gondor.hengli.com.au, dhowells@redhat.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and
	cryptomgr problem
Message-ID: <20100806083900.GA25385@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806080642.GA4642@dspnet.fr>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert <galibert@pobox.com> wrote:
>
> Of course in practice without the tests your boot would probably just
> have failed.  Badly-decrypted root partitions tend to be noticed as
> such long before trying to write to them.  Then you would have bitched
> on the list and the driver would have been fixed or removed faster
> than having to wait for you (or other people with the hardware issue)
> to notice the spew in dmesg.

So you'd rather have a box that doesn't boot rather than one
that automatically falls back to software crypto allowing you
to diagnose and report the problem.

Yes that makes a lot of sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
