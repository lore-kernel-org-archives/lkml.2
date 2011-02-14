Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1BNLGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:06:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65199 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1BNLGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TAXiKPgL13bETX4XQlY5GaVpHKDnRBJNEbuuXwCzOhD8WWf+WfQ5NA1Dml42yPbgEF
         1y0W36gx9SRwsoDi5ld5SwkEOL8gXH0QajszAbtlcH64MHtnb0KeWtAn69R5fFlA5s+5
         90fboS03a4E9zS0fUkSMLtgyJlExW88vUI8qY=
Subject: Re: [PATCH 09/17] t7166xb: mfd_cell is now implicitly available to
 drivers
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
In-Reply-To: <20110214020028.2449dbe4@debxo>
References: <20110211181101.3a4325e4@queued.net>
	 <1297675064.2854.12.camel@localhost>  <20110214020028.2449dbe4@debxo>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:04:51 +0200
Message-ID: <1297681491.2854.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 02:00 -0800, Andres Salomon wrote:
> On Mon, 14 Feb 2011 11:17:44 +0200
> Artem Bityutskiy <dedekind1@gmail.com> wrote:
> 
> > On Fri, 2011-02-11 at 18:11 -0800, Andres Salomon wrote:
> > > No need to explicitly set the cell's platform_data/data_size.
> > > 
> > > Modify clients to use mfd_get_cell helper function instead of
> > > accessing platform_data directly.
> > 
> > Wold it be possible to separate out MTD-related changes?
> > 
> 
> It's possible, sure.  Patch 09 is the only one that touches
> drivers/mtd.  It would introduce build and/or runtime problems if mtd
> and mfd trees get out of synch, however.
> 
> I was hoping to get subsystem maintainer ACKs and run everything
> through the mfd tree, if possible (though I haven't heard any feedback
> from Samuel about any of this yet).

OK, I'm not MTD maintainer, but I'd say that you can merge it via mfd
tree. I did no look at the whole set, but mtd changes look trivial and
there should not be issues with merging that via the mfd tree.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

