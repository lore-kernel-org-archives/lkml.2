Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1KKDLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 22:11:21 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58863 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463Ab1KKDLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 22:11:20 -0500
X-Sasl-enc: gYIbmHyzVq9cVuuky5Xaexksl3dlIP3gJToqbfCeV/rU 1320981078
Subject: Re: [132/262] vfs pathname lookup: Add LOOKUP_AUTOMOUNT flag
From: Ian Kent <raven@themaw.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
In-Reply-To: <20111110151507.GA29104@suse.de>
References: <20111109212713.879189869@clark.kroah.org>
	 <1320913836.3206.68.camel@perseus.themaw.net>
	 <20111110151507.GA29104@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 11:11:11 +0800
Message-ID: <1320981071.3259.10.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 07:15 -0800, Greg KH wrote:
> On Thu, Nov 10, 2011 at 04:30:36PM +0800, Ian Kent wrote:
> > On Wed, 2011-11-09 at 13:27 -0800, Greg KH wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > I was going to say we need commits
> > 815d405ceff0d6964683f033e18b9b23a88fba87 and
> > b6c8069d3577481390b3f24a8434ad72a3235594 but I see those patches are
> > present in stable-queue repo along with
> > 5c8a0fbba543d9428a486f0d1282bbcf3cf1d95a.
> > 
> > This last commit is, as Linux points out, open to question, although if
> > it was an autofs mount point that status is not really useful to the
> > user. OTOH for other fs (that use automounting) the status of the file
> > system containing the mount point might be useful but possibly
> > misleading. IMHO I'd include this commit as well.
> 
> So I don't need to do anything different here from what I am doing?

That's right, assuming the (three) commits I referred to above are in
fact going in along with the three patches here. I assume they are since
they are in the stable-queue repo.

That last paragraph just says that the third commit I referred to is
optional but recommended IMO.

Ian


