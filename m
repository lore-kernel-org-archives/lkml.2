Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1G0ILa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab1G0IL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:11:28 -0400
Subject: RE: bug in cleancache ocfs2 hook, anybody want to try cleancache?
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>,
        Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <3904dcad-951e-43ca-bd2d-1c906d0b0a9e@default>
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
	 <1307004343.2823.17.camel@menhir>
	 <75f89186-d730-4b89-b88c-899cd5674cf0@default 1307090628.2881.15.camel@menhir>
	 <3904dcad-951e-43ca-bd2d-1c906d0b0a9e@default>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 27 Jul 2011 09:13:38 +0100
Message-ID: <1311754418.2801.0.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-07-26 at 07:54 -0700, Dan Magenheimer wrote:
> > > > Also, as regards your earlier question wrt a kvm backend, I may be
> > > > tempted to have a go at writing one, but I'd like to figure out what
> > > > I'm letting myself in for before making any commitment to that,
> > 
> > > I think the hardest part is updating the tmem.c module in zcache
> > > to support multiple "clients".  When I ported it from Xen, I tore
> > > all that out.  Fortunately, I've put it back in during RAMster
> > > development but those changes haven't yet seen the light of day
> > > (though I can share them offlist).
> > 
> > I'd like to try and understand the design of the existing code before I
> > consider anything more advanced such as writing a kvm backend,
> 
> FYI, the "hardest part" (support for multiple clients) is now in
> Linus's tree as of today.  With a little hypercall and glue code,
> KVM might just work now with tmem/cleancache/frontswap.
> 
> Dan
> 

Thanks for the heads up,

Steve.


