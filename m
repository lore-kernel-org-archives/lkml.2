Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209Ab1EARS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:18:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1EARS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:18:57 -0400
Date: Sun, 1 May 2011 19:18:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using
 cluster groups v4
Message-ID: <20110501171848.GC23777@elte.hu>
References: <20110430171459.685415696@openvz.org>
 <20110430172025.663350009@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430172025.663350009@openvz.org>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

This SOB section is wrong, the last SOB must be the person sending the patch. 
Please see section "13)" in Documentation/Submittingpatches.

Thanks,

	Ingo
