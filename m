Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab2EJBKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:10:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:28181 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704Ab2EJBKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:10:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142120523"
Date: Thu, 10 May 2012 09:10:23 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use ALIGN macro instead of open-coded expression
Message-ID: <20120510011023.GF10252@yliu-dev.sh.intel.com>
References: <1336464984-30746-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20120509164549.GM19331@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509164549.GM19331@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:45:49PM +0200, David Sterba wrote:
> On Tue, May 08, 2012 at 04:16:24PM +0800, Yuanhan Liu wrote:
> > According to section 'Find open-coded helpers or macros' at
> > https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas, here
> > in the patch we use ALIGN macro to do the alignment.
> 
> Well, I wrote this section and some time later also the patches,
> http://www.spinics.net/lists/linux-btrfs/msg12747.html
> 
> but did not update the section with the status reflecting this, sorry
> that you duplicated work.

It's OK. I just didn't find those 'issue' was fixed in mainline, thus I
thought it still exist.

Thanks,
Yuanhan Liu

