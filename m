Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1EMOsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:48:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab1EMOse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:48:34 -0400
Date: Fri, 13 May 2011 16:48:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: jean.pihet@newoldbits.com
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH] perf: export power_start and power_end tracepoints
Message-ID: <20110513144830.GB32688@elte.hu>
References: <1305297838-4015-1-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305297838-4015-1-git-send-email-j-pihet@ti.com>
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


* jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> wrote:

> From: Jean Pihet <j-pihet@ti.com>
> 
> If used in a module both tracepoints need to be exported by the
> kernel.

but it's not used by any module in the kernel AFAICS, so why is this needed?

Thanks,

	Ingo
