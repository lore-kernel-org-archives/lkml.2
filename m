Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2GKQ0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:26:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61393 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2GKQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120711080446.GA17713@gmail.com>
References: <4ffc6b7b63006ca92@agluck-desktop.sc.intel.com>
	<20120711080446.GA17713@gmail.com>
Date: Wed, 11 Jul 2012 09:26:13 -0700
X-Google-Sender-Auth: -KtFJcga2Uxplip3T1EegoRm_Rg
Message-ID: <CA+8MBbJjhVgEM7bJzZOSFvT6+RBLUQV6KtdzShuBxBH_nDxo4w@mail.gmail.com>
Subject: Re: [GIT PULL] x86/mce fix (ready for 3.6 merge window)
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 1:04 AM, Ingo Molnar <mingo@kernel.org> wrote:
>  - If it's for v3.6 then the Cc: stable backport is not
>    justified. Either it's for tip:x86/urgent and then we'll
>    merge it straight away, or for tip:x86/mce for v3.6 and then
>    there's no Cc: stable tag.

The commit that this fixes was included in 3.4 - so I was thinking that this
should be backported to stable 3.4 ... but 3.4 isn't a long term release, so
it will be abandoned when 3.5 is released.

Since we are at -rc6 and this isn't a regression from the current merge,
I figured that it wasn't a candidate for immediate merge ... hence the
3.6 request. So it would appear that there isn't a way that this can make
it back to 3.4-stable.

I'll fix up all the other stuff and send a new pull (still for 3.6,
and still with
a Cc: stable for backport to 3.5)

-Tony
