Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2KESSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:18:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42194 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2KESSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:18:14 -0500
Date: Mon, 5 Nov 2012 10:18:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121105181809.GE19354@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102165123.GB3823@mtj.dyndns.org>
 <509407B7.3030904@redhat.com>
 <20121102175350.GB27843@mtj.dyndns.org>
 <50951A0E.9010103@redhat.com>
 <20121103145052.0da49071@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103145052.0da49071@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Sat, Nov 03, 2012 at 02:50:52PM +0000, Alan Cox wrote:
> > I proposed a way to implement the ultimately flexible solution (BPF) and
> > you shot it down because it was too complex.  Alan is showing you with
> > multiple examples of why the flexibility would be useful (perhaps nobody
> > would use it, but the use cases _are_ there), and you are mostly
> > ignoring them.
> 
> My feeling too - It feels to me like Tejun is trying to railroad a broken
> non-solution into the system without regards for anyone else and by
> simply dismissing any other input.

The only other use case brought up is allowing use of vendor-specific
commands while burning CDs.  Given that the usual burning has been
working well enough for years now, I don't really think that's a
strong enough reason to add full BPF filtering to SG_IO.  It's just
highly unusual thing to do and there isn't strong enough use case for
it.

To me, it feels like you guys are pushing a feature without strong
enough use case.  So, I'm still pretty strongly against it.

Thanks.

-- 
tejun
