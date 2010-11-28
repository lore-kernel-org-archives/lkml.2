Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0K1Vjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:39:35 -0500
Received: from tundra.namei.org ([65.99.196.166]:54299 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0K1Vje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:39:34 -0500
Date: Mon, 29 Nov 2010 08:39:17 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: kernel list <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopher J. PeBenito" <cpebenito@tresys.com>
Subject: Re: [PATCH 1/1] Define CAP_SYSLOG
In-Reply-To: <20101125171132.GA25703@mail.hallyn.com>
Message-ID: <alpine.LRH.2.00.1011290838450.15604@tundra.namei.org>
References: <20101125171132.GA25703@mail.hallyn.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Serge E. Hallyn wrote:

> Privileged syslog operations currently require CAP_SYS_ADMIN.  Split
> this off into a new CAP_SYSLOG privilege which we can sanely take away
> from a container through the capability bounding set.
> 
> With this patch, an lxc container can be prevented from messing with
> the host's syslog (i.e. dmesg -c).
> 
> Changelog: mar 12 2010: add selinux capability2:cap_syslog perm
> Changelog: nov 22 2010:
> 	. port to new kernel
> 	. add a WARN_ONCE if userspace isn't using CAP_SYSLOG

Applied with kernel version fix to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
