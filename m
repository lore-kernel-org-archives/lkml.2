Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2LNAA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:00:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50291 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab2LNAAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:00:55 -0500
MIME-Version: 1.0
In-Reply-To: <50CA6918.5060806@zytor.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<50CA6918.5060806@zytor.com>
Date: Thu, 13 Dec 2012 16:00:53 -0800
X-Google-Sender-Auth: H_h2FS1RWLKuiH0s4m2F5HQRXsw
Message-ID: <CAE9FiQXd66oJgo67g0B4qMRh71FnxP6RKRB9fuyjcMzMFd=YXQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 3:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> There are obviously good bits to this patchset, but I'm really starting to
> think the "pseudo-linear mode" via a trap handler -- meaning we can access
> all of memory without any extra effort -- makes more sense.  In fact, that
> way we could just build the full page tables without worrying about
> incremental bootstrap, depending on if that is a complexity win or not.
>
> Either way, this is for native only: the Xen domain builder or other similar
> entry paths should be setting up page tables that cover all of memory; I'm
> hoping Konrad and Stefano can confirm this.
>
> The only reason to go with another approach I can think of is if it makes
> 32/64-bit unification cleaner.

ok. let's wait until the new approach working.

Thanks

Yinghai
