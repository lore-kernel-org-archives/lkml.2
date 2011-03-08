Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1CHXcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:32:43 -0500
Received: from tundra.namei.org ([65.99.196.166]:44489 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab1CHXcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:32:42 -0500
Date: Wed, 9 Mar 2011 10:32:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 0/3] Cleanups to AppArmor's build
In-Reply-To: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
Message-ID: <alpine.LRH.2.00.1103091025130.28443@tundra.namei.org>
References: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, John Johansen wrote:

> The following three patches have all been out to the lkml/lsm and have sat in
> the AppArmor tree for a while.
> 
> The following changes since commit eae61f3c829439f8f9121b5cd48a14be04df451f:
> 
>   TOMOYO: Fix memory leak upon file open. (2011-03-03 10:13:26 +1100)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git security-next
> 
> John Johansen (3):
>       AppArmor: Cleanup make file to remove cruft and make it easier to read
>       AppArmor: cleanup generated files correctly
>       AppArmor: kill unused macros in lsm.c

These patches are showing up here with you as the author (not the original 
authors).  If applying raw patches, you'll need to set GIT_AUTHOR_EMAIL 
and GIT_AUTHOR_NAME, or more simply, use git-am -s on mailbox format files 
exported from your mailer.


- James
-- 
James Morris
<jmorris@namei.org>
