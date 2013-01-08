Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3AHUdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:33:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3AHUdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:33:46 -0500
Date: Tue, 8 Jan 2013 21:33:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 00/26] treewide: Add and use vsprintf extension
 %pSR
In-Reply-To: <1357624342.12749.47.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1301082133110.12134@pobox.suse.cz>
References: <cover.1355335227.git.joe@perches.com> <1357624342.12749.47.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Joe Perches wrote:

> > Remove the somewhat awkward uses of print_symbol and convert all the
> > existing uses to a new vsprintf pointer type of %pSR.
> 
> Jiri?  Are you going to do anything with this?

Joe,

yup, it's still in my TODO queue for trivial.git.

Thanks,

-- 
Jiri Kosina
SUSE Labs
