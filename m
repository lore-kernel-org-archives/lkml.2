Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2DYQ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:29:35 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:52043 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab2DYQ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:29:33 -0400
Date: Wed, 25 Apr 2012 18:29:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 0/4] kbuild: Move vmlinux link out of top-level Makefile
Message-ID: <20120425162931.GA3346@merkur.ravnborg.org>
References: <20120424194148.GA2216@merkur.ravnborg.org> <m2haw8m8ng.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2haw8m8ng.fsf@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 03:02:27AM -0700, Andi Kleen wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> >
> > What we loose by the conversion:
> > - We no longer rebuild if options to ld changes.
> 
> I think that's a problem. Can that be fixed somehow?

Thanks for the feedback, I will implement this and and repost.

	Sam
