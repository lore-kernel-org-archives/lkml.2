Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2AAOzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:55:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2AAOzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:55:52 -0500
Date: Sun, 1 Jan 2012 15:53:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org, jbarnes@virtuousgeek.org
Subject: Re: Dell Studio 1536 needs pci=nocrs to boot.
Message-ID: <20120101145354.GA1791@elte.hu>
References: <20111230193704.GA2874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111230193704.GA2874@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> Some machines don't boot unless passed pci=nocrs.
> (See https://bugzilla.redhat.com/show_bug.cgi?id=770308 for details of
>   one report. Waiting on dmidecode output for others).
> 
> Currently there is a DMI whitelist, even though the default is on.
> 
> This patch extends that dmi list to add a blacklist to automatically
> apply disable it when necessary.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

Jesse, will you take this one?

Thanks,

	Ingo
