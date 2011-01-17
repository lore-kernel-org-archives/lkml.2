Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1AQWRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:17:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1AQWRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:17:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/7] clone: kill CLONE_STOPPED
In-Reply-To: Tejun Heo's message of  Friday, 24 December 2010 15:00:51 +0100 <1293199257-11255-2-git-send-email-tj@kernel.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
	<1293199257-11255-2-git-send-email-tj@kernel.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20110117221705.C2E88180996@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 14:17:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is already stale as of commit 43bb40c.  Probably this whole series
needs a new iteration on the current tree.  I hope we can hash out these
into mergeable state pretty soon.

Thanks,
Roland
