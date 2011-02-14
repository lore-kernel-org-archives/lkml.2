Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1BNMez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:34:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab1BNMey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:34:54 -0500
Date: Mon, 14 Feb 2011 13:34:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Micha Nelissen <micha@neli.hopto.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
Message-ID: <20110214123443.GF15860@elte.hu>
References: <4D583E31.4070507@neli.hopto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D583E31.4070507@neli.hopto.org>
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


* Micha Nelissen <micha@neli.hopto.org> wrote:

> Patch is based on earlier patch from Matthew Wilcox.

Hm, there's an awful lot of 'background', 'implementation', 'advantages', 
'disadvantages', 'testing' description missing.

Thanks,

	Ingo
