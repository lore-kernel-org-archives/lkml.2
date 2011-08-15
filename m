Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1HOSeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:34:02 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:56074 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1HOSeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:34:01 -0400
Date: Mon, 15 Aug 2011 20:33:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Roskin <proski@gnu.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse: always enable endian checks
Message-ID: <20110815183358.GA31530@merkur.ravnborg.org>
References: <20110815160440.6296.95762.stgit@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815160440.6296.95762.stgit@mj>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:04:41PM -0400, Pavel Roskin wrote:
> Checks enabled by __CHECK_ENDIAN__ produce less than a half of the
> sparse warnings.  For instance, the allyesconfig configuration on
> linux-next (tag next-20110812) produces on x86_64:
> 
>                  no __CHECK_ENDIAN__   with __CHECK_ENDIAN__
> stderr bytes:    1155037               1992954 (73% increase)
> stderr lines:    10716                 18657   (74% increase)
> affected files:  1191                  1458    (22% increase)
> 
> It is no longer true that __CHECK_ENDIAN__ produces so many warnings
> that other sparse warnings drown in the noise.
> 
> Janitors going through the whole tree are already prepared to search for
> the warnings they want to fix.
> 
> The main point of this patch is to make sure that developers of a
> particular driver who use sparse rarely get all the warnings for their
> code even if they forget to specify __CHECK_ENDIAN__ or mistype it.
> 
> Some developers actually added __CHECK_ENDIAN__ to the driver makefiles
> so they don't forget to use it.  Remove them now.
> 
> Remove all references to __CHECK_ENDIAN__ from the documentation except
> the Chinese version, which would need to be updated separately.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Maybe ask Michal to merge it?

	Sam
