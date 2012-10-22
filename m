Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2JVSWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:22:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53526 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2JVSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-10-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com>
	<CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
	<alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com>
	<CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com>
Date: Mon, 22 Oct 2012 11:22:07 -0700
X-Google-Sender-Auth: V96A5lwxBQ-NVLCyg2a--QW9mig
Message-ID: <CAE9FiQWSb5D=DZRA6AceonMwBEjEgVEodvnC0aQwa4H3v+e_2A@mail.gmail.com>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:17 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Oct 22, 2012 at 6:19 AM, Stefano Stabellini

> How about put sth:
> ---
> Xen mmu requires pages from this function should be directly mapped already.
> ---
>
> or you can introduce some doc tag specially that we can out those
> assumption easily?

I add

/* Xen requires pages from this function should be directly mapped already */

in   [PATCH] x86, mm: Add alloc_low_pages(num)

hope you are happy with that.
