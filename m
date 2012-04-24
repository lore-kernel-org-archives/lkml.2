Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2DXRJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:09:49 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47438 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab2DXRJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:09:47 -0400
Date: Tue, 24 Apr 2012 13:09:43 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning in Linus' tree
Message-ID: <20120424170943.GD18865@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120424112049.45955d7025fdfb3ce182ed2e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424112049.45955d7025fdfb3ce182ed2e@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:20:49AM +1000, Stephen Rothwell wrote:
> 
> Using Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
> produced this warning:
> 
> fs/ext4/super.c: In function 'parse_options':
> fs/ext4/super.c:1600:23: warning: unused variable 'sbi' [-Wunused-variable]
> 
> Introduced by commit 26092bf52478 ("ext4: use a table-driven handler for
> mount options").  This build has CONFIG_QUOTA not set.

This should be fixed in mainline now.

Regards,

					- Ted
