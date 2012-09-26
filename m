Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2IZQIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:08:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36328 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab2IZQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:08:29 -0400
Date: Wed, 26 Sep 2012 18:08:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michal Marek <mmarek@suse.cz>
Cc: andi@firstfloor.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk
Subject: Re: [PATCH] kbuild: Do not package /boot and /lib in make tar-pkg
Message-ID: <20120926160823.GF16230@one.firstfloor.org>
References: <20120912031646.GV16230@one.firstfloor.org> <1348611445-11501-1-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348611445-11501-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 12:17:25AM +0200, Michal Marek wrote:
> There were reports of users destroying their Fedora installs by a kernel
> tarball that replaces the /lib -> /usr/lib symlink. Let's remove the
> toplevel directories from the tarball to prevent this from happening.

Looks good to me.

Please also submit to stable and all the longterms.

-Andi
