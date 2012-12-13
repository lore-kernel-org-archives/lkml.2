Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2LMMU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:20:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43490 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2LMMU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:20:57 -0500
Date: Thu, 13 Dec 2012 06:20:48 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] core_pattern: set core helpers root and namespace to
 crashing process
Message-ID: <20121213122048.GF5246@sergelap>
References: <1355255996-25953-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355255996-25953-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Neil Horman (nhorman@tuxdriver.com):
> Theres one problem I currently see with it, and that is that I'm not sure we can
> change the current behavior of how the root fs is set for the pipe reader, lest
> we break some user space expectations. As such, I've added a sysctl in this
> patch to allow administrators to globally select if a core reader specified via
> /proc/sys/kernel/core_pattern should use the global rootfs, or the (possibly)
> chrooted fs of the crashing process.

Practical question:  How is the admin to make an educated decision on
how to set the sysctl?

-serge
