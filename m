Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1FCXWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:22:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1FCXWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:22:32 -0400
Date: Fri, 03 Jun 2011 16:20:38 -0700 (PDT)
Message-Id: <20110603.162038.1779131784008384755.davem@davemloft.net>
To: wad@chromium.org
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org, paulmck@linux.vnet.ibm.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v4 12/13] sparc: select HAVE_SECCOMP_FILTER and provide
 seccomp_execve
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307133252-23259-12-git-send-email-wad@chromium.org>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
	<1307133252-23259-12-git-send-email-wad@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 03 Jun 2011 16:20:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>
Date: Fri,  3 Jun 2011 15:34:11 -0500

> Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
> system call numbering for execve and selecting HAVE_SECCOMP_FILTER.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>

Acked-by: David S. Miller <davem@davemloft.net>
