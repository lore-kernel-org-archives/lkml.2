Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab0G3C0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 22:26:18 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60562 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab0G3C0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 22:26:16 -0400
To: jmorris@namei.org
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
	<alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
	<201007301045.BFG35946.OSQFJFOHtFLVMO@I-love.SAKURA.ne.jp>
	<4C523336.2020504@canonical.com>
In-Reply-To: <4C523336.2020504@canonical.com>
Message-Id: <201007301126.AAJ12991.HOOOMtJQFVFSFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 30 Jul 2010 11:26:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Johansen wrote:
> > By the way, security/apparmor/Kconfig and security/apparmor/Makefile seems to be missing...
> 
> hrmm,
> 
> [PATCH 12/13] AppArmor: Enable configuring and building of the AppArmor security module
> 
> Kconfig and Makefiles to enable configuration and building of AppArmor.
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> ---
>  security/Kconfig             |    6 ++++++
>  security/Makefile            |    2 ++
>  security/apparmor/.gitignore |    5 +++++
>  security/apparmor/Kconfig    |   31 +++++++++++++++++++++++++++++++
>  security/apparmor/Makefile   |   24 ++++++++++++++++++++++++
>  5 files changed, 68 insertions(+), 0 deletions(-)

Indeed. security/apparmor/.gitignore and security/apparmor/Kconfig and
security/apparmor/Makefile are by error dropped when commiting.
http://git.kernel.org/?p=linux/kernel/git/jmorris/security-testing-2.6.git;a=commit;h=32bd8e5273c0be4189274ab55c4d16862f0dd87d
James, please correct.
