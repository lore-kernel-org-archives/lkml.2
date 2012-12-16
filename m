Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2LPRts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:49:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36168 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab2LPRtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:49:47 -0500
Date: Sun, 16 Dec 2012 18:49:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 05/27] x86, 64bit: clear ident mapping when kernel is
 above 512G
Message-ID: <20121216174943.GB20393@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355436141-8668-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:01:59PM -0800, Yinghai Lu wrote:
> After following patch:
> 	x86, 64bit: Set extra ident mapping for whole kernel range
> 
> We have extra ident mapping for kernel that is loaded above 1G.

What?

/me looks at next patch

Aaah, the *next* patch adds an extra ident mapping. Why don't you say
so?

> So need to clear extra pgd entry when kernel is loaded above 512g.

Why then isn't that patch following the next patch instead of coming
before it?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
