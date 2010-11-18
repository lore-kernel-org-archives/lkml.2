Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab0KRXpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:45:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52839 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0KRXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:45:22 -0500
Date: Thu, 18 Nov 2010 15:43:43 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Milton Miller <miltonm@bga.com>
Cc: Tao Ma <tao.ma@oracle.com>, ocfs2-devel@oss.oracle.com,
        Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: ocfs2: char is not always signed
Message-ID: <20101118234343.GK19821@mail.oracle.com>
Mail-Followup-To: Milton Miller <miltonm@bga.com>,
	Tao Ma <tao.ma@oracle.com>, ocfs2-devel@oss.oracle.com,
	Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
	Goldwyn Rodrigues <rgoldwyn@suse.de>
References: <1290054011_17741@mail4.comsite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290054011_17741@mail4.comsite.net>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:20:11PM -0600, Milton Miller wrote:
> Commit 1c66b360fe262 (Change some lock status member in ocfs2_lock_res
> to char.)  states that these fields need to be signed due to comparision
> to -1, but only changed the type from unsigned char to char.   However, it
> is a compiler option if char is a signed or unsigned type.  Change these
> fields to signed char so the code will work with all compilers.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
