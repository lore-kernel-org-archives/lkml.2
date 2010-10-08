Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0JHIsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:48:00 -0400
Received: from tundra.namei.org ([65.99.196.166]:53460 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab0JHIr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:47:58 -0400
Date: Fri, 8 Oct 2010 19:47:38 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        takedakn@nttdata.co.jp, lists@nerdbynature.de, kawime@gmx.de,
        jkosina@suse.cz, linux-security-module@vger.kernel.org
Subject: Re: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
In-Reply-To: <201010080626.o986QJX4002281@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.1010081947130.1559@tundra.namei.org>
References: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org> <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org> <20101008134644.8049.A69D9226@jp.fujitsu.com> <201010080626.o986QJX4002281@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Tetsuo Handa wrote:

> Date: Fri, 8 Oct 2010 14:43:22 +0900
> Subject: [PATCH] TOMOYO: Print URL information before panic().
> 
> Configuration files for TOMOYO 2.3 are not compatible with TOMOYO 2.2.
> But current panic() message is too unfriendly and is confusing users.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
