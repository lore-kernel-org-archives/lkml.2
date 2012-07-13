Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2GMNJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:09:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab2GMNJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:09:01 -0400
Date: Fri, 13 Jul 2012 15:08:58 +0200
From: Michal Marek <mmarek@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] [TRIVIAL] kconfig: remove lkc_defs.h from .gitignore
 and dontdiff
Message-ID: <20120713130858.GC18564@sepie.suse.cz>
References: <1341150294.1911.119.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341150294.1911.119.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 03:44:54PM +0200, Paul Bolle wrote:
> Commit 5a6f8d2bd9e3392569ed6f29ea4d7210652f929b ("kconfig: nuke
> LKC_DIRECT_LINK cruft") removed all traces of lkc_defs.h from the tree.
> Remove its entries in dontdiff and kconfig's .gitignore file too.

Applied to kbuild.git#kconfig. Thanks.

Michal
