Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3AJNXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:23:53 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64023 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3AJNXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:23:52 -0500
X-Nat-Received: from [202.181.97.72]:52767 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1357824212.20910
To: john.johansen@canonical.com, jmorris@namei.org
Cc: casey@schaufler-ca.com, sfr@canb.auug.org.au,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, eparis@redhat.com, keescook@chromium.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <50EB9A5E.1080306@schaufler-ca.com>
	<alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
	<50EC8447.1000301@canonical.com>
	<alpine.LRH.2.02.1301100028160.5423@tundra.namei.org>
	<50EE9733.2060409@canonical.com>
In-Reply-To: <50EE9733.2060409@canonical.com>
Message-Id: <201301102223.IAB57337.FOOOtSLJMFFVHQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 10 Jan 2013 22:23:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012013 #9022807, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Johansen wrote:
> On 01/09/2013 05:28 AM, James Morris wrote:
> > On Tue, 8 Jan 2013, John Johansen wrote:
> > 
> >>> I'd say we need to see the actual use-case for Smack and Apparmor being 
> >>> used together, along with at least one major distro committing to support 
> >>> this.
> >>>
> >>>
> >> Ubuntu is very interested in stacking
> > 
> > Which modules?
> > 
> Well Yama which has now been special cased, and in the past there has been
> discussion about other special case LSMs like case is proposing for module
> loading. There has been interest around both selinux + apparmor and
> smack + apparmor. I am not sure of all of the use cases that have lead to
> such question but some of them have been around containers, with say
> selinux on the host and apparmor in the container, or visa versa.

My case is I want to use SELinux (or SMACK or something else) for isolation
purpose (little user configuration required) and TOMOYO (or AppArmor or
something else) for behaviour restriction purpose (mostly user configurable
part). SELinux + TOMOYO is a placeholder for stacking.
