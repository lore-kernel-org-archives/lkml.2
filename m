Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1GZOzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:55:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47704 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1GZOy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:54:57 -0400
MIME-Version: 1.0
Message-ID: <3904dcad-951e-43ca-bd2d-1c906d0b0a9e@default>
Date: Tue, 26 Jul 2011 07:54:31 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>,
        Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org
Subject: RE: bug in cleancache ocfs2 hook, anybody want to try cleancache?
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
 <1307004343.2823.17.camel@menhir>
 <75f89186-d730-4b89-b88c-899cd5674cf0@default
 1307090628.2881.15.camel@menhir>
In-Reply-To: <1307090628.2881.15.camel@menhir>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E2ED539.0076,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Also, as regards your earlier question wrt a kvm backend, I may be
> > > tempted to have a go at writing one, but I'd like to figure out what
> > > I'm letting myself in for before making any commitment to that,
> 
> > I think the hardest part is updating the tmem.c module in zcache
> > to support multiple "clients".  When I ported it from Xen, I tore
> > all that out.  Fortunately, I've put it back in during RAMster
> > development but those changes haven't yet seen the light of day
> > (though I can share them offlist).
> 
> I'd like to try and understand the design of the existing code before I
> consider anything more advanced such as writing a kvm backend,

FYI, the "hardest part" (support for multiple clients) is now in
Linus's tree as of today.  With a little hypercall and glue code,
KVM might just work now with tmem/cleancache/frontswap.

Dan

