Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2HXX53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 19:57:29 -0400
Received: from noserose.net ([66.220.18.76]:54872 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754575Ab2HXX5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 19:57:14 -0400
Message-Id: <1345852631.24885@cat.he.net>
Date: Fri, 24 Aug 2012 16:57:11 -0700
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: Re: [PATCH 00/14] aoe driver v49 performance and usability improvements
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[second send after HTML part made vger reject my first email]

On 32 Aug 2012, Ed Cashin writes:

> These patches go a long way to updating the in-kernel aoe driver with
> the changes that have been in the coraid.com-distributed version,
> bringing it from (aoe internal) version 47 to version 49.  They apply
> to commit 23dcfa61bac244e1 of the mainline git tree.

Just a heads up: A colleague found a list_del corruption warning using
3.5.2 with these patches, but the warning also occurs without these
patches, so I plan to do a git bisect to find out when the regression
occurred.  The warning appears to be for the events of the bdi->completions
when blk_cleanup_queue is called during "rmmod aoe".

-- 
  Ed
