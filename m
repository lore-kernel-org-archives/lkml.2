Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab1EWVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:16:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37273 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1EWVQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:16:54 -0400
Date: Mon, 23 May 2011 17:16:17 -0400 (EDT)
Message-Id: <20110523.171617.1123528853189250599.davem@davemloft.net>
To: jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110523134339.609508fe@jbarnes-vaio.home>
References: <20110523134339.609508fe@jbarnes-vaio.home>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 May 2011 14:16:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 23 May 2011 13:43:39 -0700

> The following changes since commit
> 2f666bcf757cb72549f360ef6da02f03620a48b6:
> 
>   Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-04-19 18:32:57 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next
> 
> Ok, with the recent fixes to the resource code, we ought to be able to
> re-enable the code that tries to reallocate bridge resources as
> needed.  As with last time we tried this, we'll keep the revert trigger
> light; if this causes any problems we can't quickly root cause we'll
> yank it back out.
> 
> Other than that, there are a few enabling features for PCIe 2.1
> extensions here, and some support code for KVM, along with the usual
> collection of fixes.

Jesse, I submitted a warning fixe a few months ago and they don't
seem to be integrated.

http://marc.info/?l=-pci&m=130146645206948&w=2
