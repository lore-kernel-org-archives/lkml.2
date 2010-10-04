Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0JDJuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:50:03 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47756 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab0JDJuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:50:02 -0400
To: Andy Whitcroft <apw@canonical.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com, neilb@suse.de,
        viro@zeniv.linux.org.uk, apw@canonical.com
In-reply-to: <1285955282-10240-1-git-send-email-apw@canonical.com> (message
	from Andy Whitcroft on Fri, 1 Oct 2010 18:48:00 +0100)
Subject: Re: [PATCH 0/2] overlayfs: module and statfs fixes
References: <1285955282-10240-1-git-send-email-apw@canonical.com>
Message-Id: <E1P2hgC-0001oA-Gw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 04 Oct 2010 11:49:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Oct 2010, Andy Whitcroft wrote:
> Just been playing with overlayfs and hit a couple of issues.  First I
> was not able to build this filesystem as a module.  Second statfs support
> was missing.  Following this email are a couple of patches which I used to
> fix these up.  I am not 100% sure the statfs approach is quite right, but
> its not clear the semantics can ever be correct in the face of an overlay.

Applied both patches and pused to the overlayfs.v3 branch.  Also
pushed a patch changing two BUG_ONs to WARN_ON.

> 
> With these applied I was able to drop an overlay over the top of a very
> out of date Ubuntu chroot and upgrade it to the latest and greatest;
> all without incident.

Great, thanks for testing.

Miklos
