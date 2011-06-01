Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab1FAAZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:25:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:39146 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab1FAAZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:25:39 -0400
Date: Wed, 1 Jun 2011 10:25:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AppArmor: fix oops in apparmor_setprocattr
In-Reply-To: <20110531183141.GH19633@outflux.net>
Message-ID: <alpine.LRH.2.00.1106011024150.16178@tundra.namei.org>
References: <20110531183141.GH19633@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Kees Cook wrote:

> When invalid parameters are passed to apparmor_setprocattr a NULL deref
> oops occurs when it tries to record an audit message. This is because
> it is passing NULL for the profile parameter for aa_audit. But aa_audit
> now requires that the profile passed is not NULL.
> 
> Fix this by passing the current profile on the task that is trying to
> setprocattr.

Is this trigger able by unprivileged users?

>From which upstream commit is this an issue?


- James
-- 
James Morris
<jmorris@namei.org>
