Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2KMS6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:58:37 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49453 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2KMS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:58:36 -0500
MIME-Version: 1.0
In-Reply-To: <50A289BB.5030009@zytor.com>
References: <20121112193044.GA11615@phenom.dumpdata.com>
	<1352755122-25660-1-git-send-email-yinghai@kernel.org>
	<1352755122-25660-29-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1211131638060.28049@kaball.uk.xensource.com>
	<50A289BB.5030009@zytor.com>
Date: Tue, 13 Nov 2012 10:58:34 -0800
X-Google-Sender-Auth: PiUyC4t5aNhJm-cSCxQn2uwuxAE
Message-ID: <CAE9FiQUw3Dt1N6ascvnGBdrDuADPaTfC9vdNW86cEv6hBWTYkQ@mail.gmail.com>
Subject: Re: [PATCH 28/46] x86, mm: Add pointer about Xen mmu requirement for alloc_low_pages
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 9:56 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> When making references to git commits, please include the title of the
> commit:
>
>  *
>  * Changing that is likely to break Xen, see commit:
>  *
>  *    279b706 x86,xen: introduce x86_init.mapping.pagetable_reserve
>  *
>  * for detailed information.
>
> Otherwise it might be very confusing if we have an abbreviated hash
> collision or end up having to change git to use another hash system.

updated to your version.
