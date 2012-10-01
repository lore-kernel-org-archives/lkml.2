Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2JAWVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:21:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab2JAWVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:21:24 -0400
Date: Tue, 2 Oct 2012 00:21:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the trivial tree with the mfd tree
In-Reply-To: <20120912134349.f1dd0f4d050dd4834623e57b@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1210020018340.23544@pobox.suse.cz>
References: <20120912134349.f1dd0f4d050dd4834623e57b@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/video/backlight/88pm860x_bl.c between commit a6ccdcd98c39 ("mfd:
> 88pm860x: Use REG resource for backlight") from the mfd tree and commit
> e1c9ac420ef1 ("Revert "backlight: fix memory leak on obscure error
> path"") from the trivial tree.
> 
> I just used the version from the mfd tree and can carry the fix as
> necessary (no action is required).

Samuel,

Linus has just pulled from trivial.git, so could you please make sure this 
is taken care of (*) in your next pull request? Thanks a lot!

(*) either by resolving the conflict in your tree first, or mentioning it 
explicitly in your pull request to Linus.

-- 
Jiri Kosina
SUSE Labs
