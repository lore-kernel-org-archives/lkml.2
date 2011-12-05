Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1LEMe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:34:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1LEMe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:34:27 -0500
Date: Mon, 5 Dec 2011 13:32:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH v4] x86, efi: Calling __pa() with an ioremap'd address is
 invalid
Message-ID: <20111205123217.GF3143@elte.hu>
References: <1321621751-3650-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321621751-3650-1-git-send-email-matt@console-pimps.org>
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


* Matt Fleming <matt@console-pimps.org> wrote:

> Zhang, it'd be good to make sure that this still actually 
> fixes your problem on CONFIG_X86_32. Also, if anyone has a 
> Macbook Pro/Macbook Air, please make sure that this patch 
> doesn't cause your machine to reboot/hang, as those machines 
> tend to be the ones that this problem.

Ping - has it been tested on an affected box, can we apply it to 
the x86 tree?

Thanks,

	Ingo
