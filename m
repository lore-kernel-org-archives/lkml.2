Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2BOXlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:41:20 -0500
Received: from tundra.namei.org ([65.99.196.166]:34662 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab2BOXlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:41:18 -0500
Date: Thu, 16 Feb 2012 10:41:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Yama: add PR_SET_PTRACER_ANY
In-Reply-To: <20120215004809.GO20420@outflux.net>
Message-ID: <alpine.LRH.2.02.1202161031260.30179@tundra.namei.org>
References: <20120215004809.GO20420@outflux.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Kees Cook wrote:

> For a process to entirely disable Yama ptrace restrictions, it can use
> the special PR_SET_PTRACER_ANY pid to indicate that any otherwise allowed
> process may ptrace it. This is stronger than calling PR_SET_PTRACER with
> pid "1" because it includes processes in external pid namespaces. This is
> currently needed by the Chrome renderer, since its crash handler (Breakpad)
> runs external to the renderer's pid namespace.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

-- 
James Morris
<jmorris@namei.org>
