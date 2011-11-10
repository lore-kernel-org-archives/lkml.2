Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586Ab1KJPSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:18:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817Ab1KJPSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:18:10 -0500
Date: Thu, 10 Nov 2011 07:15:07 -0800
From: Greg KH <gregkh@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [132/262] vfs pathname lookup: Add LOOKUP_AUTOMOUNT flag
Message-ID: <20111110151507.GA29104@suse.de>
References: <20111109212713.879189869@clark.kroah.org>
 <1320913836.3206.68.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320913836.3206.68.camel@perseus.themaw.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 04:30:36PM +0800, Ian Kent wrote:
> On Wed, 2011-11-09 at 13:27 -0800, Greg KH wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> I was going to say we need commits
> 815d405ceff0d6964683f033e18b9b23a88fba87 and
> b6c8069d3577481390b3f24a8434ad72a3235594 but I see those patches are
> present in stable-queue repo along with
> 5c8a0fbba543d9428a486f0d1282bbcf3cf1d95a.
> 
> This last commit is, as Linux points out, open to question, although if
> it was an autofs mount point that status is not really useful to the
> user. OTOH for other fs (that use automounting) the status of the file
> system containing the mount point might be useful but possibly
> misleading. IMHO I'd include this commit as well.

So I don't need to do anything different here from what I am doing?

confused,

greg k-h
