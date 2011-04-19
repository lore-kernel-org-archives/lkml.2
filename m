Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1DSRpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:45:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39572 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1DSRpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:45:03 -0400
Date: Tue, 19 Apr 2011 19:44:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH -v2 2/2] x86, MCE: Drop the default decoding notifier
Message-ID: <20110419174446.GA13616@elte.hu>
References: <1303135222-17118-2-git-send-email-bp@amd64.org>
 <20110419171340.GE6640@elte.hu>
 <20110419173521.GA25374@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419173521.GA25374@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> +	if (ret != NOTIFY_STOP)
> +		printk_ratelimited(KERN_EMERG HW_ERR
> +				   "Run the above through 'mcelog --ascii'\n");

pr_emerg_ratelimited() would allow you to keep that broken line happy?

Thanks,

	Ingo
