Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab1DMGws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 02:52:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39280 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab1DMGwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 02:52:47 -0400
Date: Wed, 13 Apr 2011 08:52:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: torvalds@linux-foundation.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] X86 platform drivers updates
Message-ID: <20110413065232.GA26072@elte.hu>
References: <20110412153130.GA32247@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110412153130.GA32247@srcf.ucam.org>
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

>       platform-drivers: x86: pmic: Restore the dropped buslock/unlock

>  drivers/platform/x86/intel_pmic_gpio.c          |   43 +-

This commit (now upstream) does not build at all on allyes64:

  drivers/platform/x86/intel_pmic_gpio.c:212:19: error: ‘pmic_irq_buslock’ undeclared here

Thanks,

	Ingo
