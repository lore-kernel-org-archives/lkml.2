Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0D0Czg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 22:55:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57297 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0D0Czf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 22:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B5yEqau42o3DhySKQy+J6ayhFXJcy0zcEb1bLCgA4fk/vlRM410jKT58kzyr7HFwFr
         X9RiGSibzoMWPB+ig28Ha/O/An9XqUPwXCWWn1yg26v5+95xkZDiVjZeHkhbbrj5H3oS
         CtYvZYCKXKMCX9OLq0KH2NhJbA7g4Fwplsce8=
Date: Tue, 27 Apr 2010 04:55:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Next <linux-next@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: A few tree inclusion update requests
Message-ID: <20100427025530.GE5695@nowhere>
References: <20100410134221.GC5204@nowhere> <20100413094618.76ac20a8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413094618.76ac20a8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 09:46:18AM +1000, Stephen Rothwell wrote:
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and 
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.


Hi Stephen,

Could you please integrate the following new tree in linux-next?

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/ioctl

Thanks!

