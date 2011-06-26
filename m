Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1FZXXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:23:06 -0400
Received: from tundra.namei.org ([65.99.196.166]:57376 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092Ab1FZXV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 19:21:58 -0400
Date: Mon, 27 Jun 2011 09:20:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Evans <scarybeasts@gmail.com>
cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter
 is and how it works.
In-Reply-To: <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org> <1308875813-20122-5-git-send-email-wad@chromium.org> <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011, Chris Evans wrote:

> With patches like these, there can be the concern: will anyone actually use
> it??

It's likely to be used by kvm/qemu to help protect against vm break-outs.

-- 
James Morris
<jmorris@namei.org>
