Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab1FXN52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:57:28 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4820 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1FXN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:57:26 -0400
X-Greylist: delayed 1828 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 09:57:25 EDT
Date: Fri, 24 Jun 2011 09:26:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-karma-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 04/37] Remove unneeded version.h includes from fs/
Message-ID: <20110624132620.GA5694@hash.lan>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1106232358330.17688@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106232358330.17688@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 11:59:32PM +0200, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h were not needed in fs/ (fs/btrfs/ctree.h and
> fs/omfs/file.c).
> This patch removes them.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks, omfs part was leftover cruft from its time out-of-tree.

FWIW,
Acked-by: Bob Copeland <me@bobcopeland.com>
-- 
Bob Copeland %% www.bobcopeland.com

