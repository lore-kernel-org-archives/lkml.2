Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab1FADhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:37:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44860 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab1FADhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:37:21 -0400
Date: Tue, 31 May 2011 20:35:27 -0700 (PDT)
Message-Id: <20110531.203527.92431501.davem@davemloft.net>
To: wad@chromium.org
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3 12/13] sparc: select HAVE_SECCOMP_FILTER and provide
 seccomp_execve
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306897845-9393-12-git-send-email-wad@chromium.org>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
	<1306897845-9393-12-git-send-email-wad@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 May 2011 20:35:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>
Date: Tue, 31 May 2011 22:10:44 -0500

> Facilitate the use of CONFIG_SECCOMP_FILTER by wrapping compatibility
> system call numbering for execve and selecting HAVE_SECCOMP_FILTER.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>

Acked-by: David S. Miller <davem@davemloft.net>
