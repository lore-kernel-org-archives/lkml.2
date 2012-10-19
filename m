Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab2JSSJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:09:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46450 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2JSSJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:09:02 -0400
MIME-Version: 1.0
In-Reply-To: <20121019001619.GA24832@codeaurora.org>
References: <20121019001619.GA24832@codeaurora.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 11:08:40 -0700
X-Google-Sender-Auth: P6Q9PncNGxV9_R9huSMXdJidmfI
Message-ID: <CA+55aFwqB7KcPTLuiirTS9rSz1YiUfxJQ6BNbLR2SupfBt5UWg@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull the Hexagon branch
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 5:16 PM, Richard Kuo <rkuo@codeaurora.org> wrote:
>
> Please pull the following small changes for the Hexagon arch.  It includes
> the Hexagon UAPI changes from David Howells and some CR marking changes for
> the transition from Code Aurora to Linux Foundation.

Can you please also check Al Viro's email titled "new
execve/kernel_thread design". He has hexagon changes he'd like tested,
and you were cc'd on the emails. There's a "arch-hexagon" branch in
his tree that needs testing and then fixing-or-acking.

             Linus
