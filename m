Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1CAGR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 01:17:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab1CAGRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 01:17:55 -0500
Date: Tue, 1 Mar 2011 07:17:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <lenb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Luming Yu <luming.yu@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [build fix] ACPI: Fix build for CONFIG_NET unset
Message-ID: <20110301061731.GA9344@elte.hu>
References: <20101220200013.df8fbc88.sfr@canb.auug.org.au>
 <201102282342.59407.rjw@sisk.pl>
 <4D6C370F.1040104@oracle.com>
 <201103010112.19835.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103010112.19835.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: ACPI: Fix build for CONFIG_NET unset

Acked-by: Ingo Molnar <mingo@elte.hu>

(I also changed the subject line to signal that a patch has been submitted.)

Thanks,

	Ingo
