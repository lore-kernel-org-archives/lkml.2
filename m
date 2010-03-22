Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0CVNfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:35:11 -0400
Received: from www.tglx.de ([62.245.132.106]:58989 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0CVNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:35:09 -0400
Date: Mon, 22 Mar 2010 14:34:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86: kill smpboot_hooks.h
In-Reply-To: <1269221770-9667-5-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1003221429160.3147@localhost.localdomain>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org> <1269221770-9667-5-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Yinghai Lu wrote:

> only one user, move it back to smpboot.c
> 
> remove smpboot_clear_io_apic, and only keep smpboot_clear_io_apic_irqs.
> 
> and check nr_legacy_irqs before clear it.

This is not the way how we do that. We move code in one patch and then
do modification in the follow up patch. Doing both makes it harder
than necessary to follow the code change.

As a side note, that changelog for the removal of
smpboot_clear_io_apic is not telling anything why that change is
functional equivivalent to the original code. And I doubt that it's
correct.

Thanks,

	tglx
