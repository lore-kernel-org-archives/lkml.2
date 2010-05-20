Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0ETIAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:00:45 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:59817 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0ETIAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:00:44 -0400
Date: Thu, 20 May 2010 10:00:42 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: Storage class should be before const qualifier
Message-ID: <20100520080042.GW9489@distanz.ch>
References: <1274101969-21109-1-git-send-email-tklauser@distanz.ch> <20100517131335.GA12126@redhat.com> <20100517132748.GQ9489@distanz.ch> <1274104497.1705.589.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274104497.1705.589.camel@Joe-Laptop.home>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-05-17 at 15:54:57 +0200, Joe Perches <joe@perches.com> wrote:
> On Mon, 2010-05-17 at 15:27 +0200, Tobias Klauser wrote:
> > On 2010-05-17 at 15:13:35 +0200, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > On Mon, May 17, 2010 at 03:12:49PM +0200, Tobias Klauser wrote:
> > > > The C99 specification states in section 6.11.5:
> > > > The placement of a storage-class specifier other than at the beginning
> > > > of the declaration specifiers in a declaration is an obsolescent
> > > > feature.
> > > > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > > Just to clarify: does some compiler/checker actually barf on this?
> > GCC does emit a warning if the options '-std=c99 -W -Wall' are present.
> > ICC also does warn about this, though I don't know whether this depends
> > on any commandline options.
> 
> Perhaps others should be converted as well.
> 
> $ grep -rPl --include=*.[ch] "^[ \t]*const\s+static" * | \
>   xargs sed -i -r -e 's/^[ \t]*const[ \t]+static\b/static const/g' 

Thanks, I slightly modified this (to preserve possible whitespaces at
the beginning of the line) and will submit the patches to the respective
maintainers/mailinglists.

Tobias
