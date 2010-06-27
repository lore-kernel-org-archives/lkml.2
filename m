Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0F0SWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 14:22:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0F0SWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 14:22:43 -0400
Date: Sun, 27 Jun 2010 14:22:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mingming Cao <mcao@us.ibm.com>, Steve French <smfrench@gmail.com>,
       DENIEL Philippe <philippe.deniel@cea.fr>,
       David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>,
       Jeff Layton <jlayton@samba.org>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
 register them
Message-ID: <20100627182229.GA492@infradead.org>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net>
 <4C24A606.5040001@suse.de>
 <1277220214-3597-1-git-send-email-sjayaraman@suse.de>
 <9822.1277312573@redhat.com>
 <22697.1277470549@redhat.com>
 <18628.1277502398@redhat.com>
 <20100625182651.36800d06@tlielax.poochiereds.net>
 <AANLkTilOTrHLvLv4XWYZO6xCnYZgYT7gO2M-oKZ6VvqM@mail.gmail.com>
 <OFB55E8EC7.E8DD23D5-ON8725774E.0004921E-8825774E.0004CC31@us.ibm.com>
 <871vbscpce.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871vbscpce.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 11:47:21PM +0530, Aneesh Kumar K. V wrote:
> NFS ganesha pNFS also had a requirement for getting i_generation and
> inode number in userspace. So may be we should now look at updating
> stat or add a variant syscall that include i_generation and create time
> in the return value

What's missing in knfsd that you feel the sudden urge to move backwards
to a userspace nfsd (one with a horribly crappy codebase, too).

