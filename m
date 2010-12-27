Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0L0UyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 15:54:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0L0UyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 15:54:15 -0500
Date: Mon, 27 Dec 2010 12:52:42 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Fasheh <mfasheh@suse.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH -next] ocfs2: fix build for OCFS2_FS_STATS not enabled
Message-ID: <20101227205242.GA30474@mail.oracle.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Mark Fasheh <mfasheh@suse.com>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
 <20101227115508.8136331b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227115508.8136331b.randy.dunlap@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 11:55:08AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_OCFS2_FS_STATS is not enabled:
> 
> fs/ocfs2/cluster/tcp.c:1254: error: implicit declaration of function 'o2net_update_recv_stats'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Mark Fasheh <mfasheh@suse.com>
> Cc:	Joel Becker <joel.becker@oracle.com>
> Cc:	ocfs2-devel@oss.oracle.com

Acked-by: Joel Becker <joel.becker@oracle.com>

Do you want to push it or would you like me to?

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
