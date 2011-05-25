Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1EYOwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:52:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35681 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1EYOws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:52:48 -0400
Date: Wed, 25 May 2011 09:52:45 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
        security@kernel.org, kees@ubuntu.com,
        Tavis Ormandy <taviso@cmpxchg8b.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [Security] Fwd: Oops (bad memory deref) in slab_alloc() due to
 filp_cachep holding incorrect values
Message-ID: <20110525145245.GA17600@mail.hallyn.com>
References: <BANLkTikfqV57AtCckh99jAT2O38mM6MzTA@mail.gmail.com>
 <BANLkTikey3L4doiHY=__=690TZNsXqRHUQ@mail.gmail.com>
 <alpine.DEB.2.00.1105231133580.29047@router.home>
 <BANLkTi=-xRRxi4CtxMLt0VgTJWSdiVQugw@mail.gmail.com>
 <BANLkTin1zhuA3z61cBWwJws+P1-xA5bGZA@mail.gmail.com>
 <BANLkTikp4VweUE+JrkXRSJ-8kEEcPKpw8g@mail.gmail.com>
 <BANLkTimB6pQyux4XEqqEUvuPGsZ2Bw0L8w@mail.gmail.com>
 <20110525144400.GA26206@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525144400.GA26206@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge Hallyn (serge.hallyn@canonical.com):
> Fooi, it looks like all users of cred_alloc_blank() may need to be
> audited wrt commit 47a150edc2ae734c0f4bf50aa19499e23b9a46f8.

Fortunately there appear to be no other users.

David, is there any other place that a cred gets created and used
without it coming from copy_creds()?

thanks,
-serge
