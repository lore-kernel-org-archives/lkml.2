Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0G3Dud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 23:50:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:36223 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab0G3Dub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 23:50:31 -0400
Date: Fri, 30 Jul 2010 13:50:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
In-Reply-To: <201007301126.AAJ12991.HOOOMtJQFVFSFL@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.00.1007301349260.8846@tundra.namei.org>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com> <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org> <201007301045.BFG35946.OSQFJFOHtFLVMO@I-love.SAKURA.ne.jp> <4C523336.2020504@canonical.com>
 <201007301126.AAJ12991.HOOOMtJQFVFSFL@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010, Tetsuo Handa wrote:

> Indeed. security/apparmor/.gitignore and security/apparmor/Kconfig and
> security/apparmor/Makefile are by error dropped when commiting.
> http://git.kernel.org/?p=linux/kernel/git/jmorris/security-testing-2.6.git;a=commit;h=32bd8e5273c0be4189274ab55c4d16862f0dd87d
> James, please correct.

Yep, I had to edit a couple of those files and they did not get added 
properly (I'm sure I typed git-add...).

Should be fixed now, please test.


-- 
James Morris
<jmorris@namei.org>
