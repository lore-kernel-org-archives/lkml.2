Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab2EJQhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:37:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62038 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab2EJQhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:37:19 -0400
Date: Thu, 10 May 2012 09:37:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>,
        Orion Poplawski <orion@cora.nwra.com>
Subject: Re: [ 061/167] [PATCH] nfsd: dont fail unchecked creates of
 non-special files
Message-ID: <20120510163715.GE18522@kroah.com>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055038.318026845@decadent.org.uk>
 <20120509070758.GC32230@burratino>
 <1336566991.8274.348.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336566991.8274.348.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 01:36:31PM +0100, Ben Hutchings wrote:
> On Wed, 2012-05-09 at 02:07 -0500, Jonathan Nieder wrote:
> > Ben Hutchings wrote:
> > 
> > > 3.2-stable review patch.
> > [...]
> > > commit 9dc4e6c4d1182d34604ea40fef641775f5b15456 upstream.
> > [...]
> > > [bwh: Backported to 3.2: use &resfh, not resfh]
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > 
> > Looks good.  Greg, I think this backport can be reused for 3.3.y,
> > where the upstream patch similarly does not apply for lack of
> > v3.4-rc1~40^2~19 ("nfsd4: reduce do_open_lookup() stack usage").
> 
> Thanks, I had made a note that this should be queued for 3.3.y as well.

Thanks, now applied.

greg k-h
