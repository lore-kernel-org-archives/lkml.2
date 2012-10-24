Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2JXGDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:03:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45229 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2JXGDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:03:41 -0400
Date: Wed, 24 Oct 2012 08:03:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 031/193] arch/x86: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024060336.GB20007@gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-32-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-32-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
