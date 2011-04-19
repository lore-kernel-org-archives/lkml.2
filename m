Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1DSGHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:07:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1DSGHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:07:00 -0400
Date: Tue, 19 Apr 2011 08:06:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Narendra_K@Dell.com
Cc: viro@zeniv.linux.org.uk, jbarnes@virtuousgeek.org, mjg@redhat.com,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Shyam_Iyer@Dell.com, Matt_Domsch@Dell.com,
        Charles_Rose@Dell.com, Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Message-ID: <20110419060641.GA26624@elte.hu>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Narendra_K@Dell.com <Narendra_K@Dell.com> wrote:

> This patch fixes the following build breakage introduced by the patch
> '[PATCH V3] Export ACPI _DSM provided firmware instance number and string to
> sysfs'.
> 
> drivers/built-in.o: In function `T.647':
> pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'

btw., this build bug still triggers upstream with .39-rc4 - any plans on when 
this regression will be fixed?

Thanks,

	Ingo
