Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1JLPhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:37:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1JLPhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:37:20 -0400
Date: Wed, 12 Oct 2011 17:35:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20111012153541.GB26529@elte.hu>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
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


* Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:

> From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Same question as for the other patch, was this intended to be:

  From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
 
  Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
  Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

?

Thanks,

	Ingo
