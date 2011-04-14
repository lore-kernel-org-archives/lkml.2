Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab1DNTOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492Ab1DNTOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:14:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1302756608.2854.10.camel@perseus.themaw.net>
References: <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> 
To: Ian Kent <ikent@redhat.com>
Cc: dhowells@redhat.com, Michal Suchanek <hramrach@centrum.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        miklos@szeredi.hu, Christoph Hellwig <hch@infradead.org>
Subject: Re: Unionmount status?
Date: Thu, 14 Apr 2011 20:14:08 +0100
Message-ID: <24792.1302808448@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <ikent@redhat.com> wrote:

> I believe David was working to update the patches and his silence
> indicates he is probably bogged down with other priority work. If that's
> the case, and your still interested, I might be able to help updating
> the series some time soon. I haven't reviewed any of Val's series posts
> for a while now so I'd need to catch up with the current state of the
> project first.
> 
> I guess the first thing is to find out if David has made any progress,
> David?

I started trying to forwardport them.  It's not trivial because of Nick's RCU
pathwalk patches.

However, I noticed that the collection of patches I was working on wasn't the
most recent in Val's GIT tree, so I stopped work on them whilst I found out
from Val which was the correct branch to use.  Her reply came just before I
jetted out to LSF, and I haven't got round to working on them again.

David
