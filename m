Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1ERVIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:08:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1ERVIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:08:01 -0400
Date: Wed, 18 May 2011 23:07:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rao, Nikhil" <nikhil.rao@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  x86: Removing unnecessary check in detect_ht
Message-ID: <20110518210754.GA28476@elte.hu>
References: <43F901BD926A4E43B106BF17856F0755018E1CF482@orsmsx508.amr.corp.intel.com>
 <4FF5AC937153B0459463C1A88EB478F2010DFD3D3F@orsmsx505.amr.corp.intel.com>
 <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
 <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
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


* Rao, Nikhil <nikhil.rao@intel.com> wrote:

> This patch removes a check that prevents correct CPU topology setup
> when cpuid extensions for topology enumeration are not supported and
> the number of processors reported to the OS is smaller than 
> smp_num_siblings

What bad effect was observed, exactly? An annoying warning in the bootlog and 
incorrect scheduler domain setup (SMP instead of SMT) - or something else as 
well?

Thanks,

	Ingo
