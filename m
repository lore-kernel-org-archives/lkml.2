Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0IBQui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:50:38 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33518 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab0IBQuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:50:37 -0400
Date: Thu, 2 Sep 2010 18:50:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: gerg@snapgear.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select
	m68knommu contributions
Message-ID: <20100902165035.GB24011@merkur.ravnborg.org>
References: <20100902135438.GA23729@merkur.ravnborg.org> <19747.1283422807@redhat.com> <20100902102158.19806.14133.stgit@warthog.procyon.org.uk> <24082.1283440358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24082.1283440358@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 04:12:38PM +0100, David Howells wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > This was exactly the reason why __uClinux__ was used in the first place.
> 
> That shouldn't be used in kernel headers.  It should be !CONFIG_MMU.

Thats preferable - yes.
But in headers that are exported we cannot rely on CONFIG_MMU,
and Andreas could point out two headers that are exported
where your patch replaced __uClinux__ with CONFIG_MMU.

Thats wrong.
I assume you aggree on this?

	Sam
