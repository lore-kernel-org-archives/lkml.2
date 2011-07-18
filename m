Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1GUCwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 22:52:38 -0400
Received: from ozlabs.org ([203.10.76.45]:52698 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1GUCwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 22:52:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>, Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V3
In-Reply-To: <1310626276-4541-1-git-send-email-abogani@kernel.org>
References: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com> <1310626276-4541-1-git-send-email-abogani@kernel.org>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 19 Jul 2011 09:08:29 +0930
Message-ID: <87mxgb2m8a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 08:51:16 +0200, Alessio Igor Bogani <abogani@kernel.org> wrote:
> The commit f02e8a6 sorts symbols placing each of them in its own elf section.
> The sorting and merging into the canonical sections are done by the linker.
> Unfortunately modpost to generate Module.symvers file parses vmlinux
> (already linked) and all modules object files (which aren't linked yet).
> These aren't sanitized by the linker yet. That breaks modpost that can't
> detect license properly for modules. This patch makes modpost aware of
> the new exported symbols structure.
> 
> Thanks to Arnaud Lacombe <lacombar@gmail.com> and Anders Kaseorg
> <andersk@ksplice.com> for providing useful suggestions about code.
> 
> This work was supported by a hardware donation from the CE Linux Forum.

Applied.

Thanks!
Rusty.
