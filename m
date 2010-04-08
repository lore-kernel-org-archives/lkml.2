Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0DHUpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:45:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44873 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab0DHUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:45:18 -0400
Date: Thu, 8 Apr 2010 16:39:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-wireless@vger.kernel.org
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
	v2.6.34-rc3-406 oops with 4965AGN wireless
Message-ID: <20100408203952.GE2999@tuxdriver.com>
References: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com> <20100408201952.GD2999@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408201952.GD2999@tuxdriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 04:19:53PM -0400, John W. Linville wrote:
> On Fri, Apr 09, 2010 at 03:27:53AM +0800, Jeff Chua wrote:
> 
> > Wey, the patch doesn't apply cleanly. I believe you meant "iwl_" instead  
> > of "iwlagn_".
> 
> He based his patch on wireless-testing (or something similar), where
> iwlagn_ is the proper prefix for the functions in question.

"She based her patch..." -- my apologies!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
