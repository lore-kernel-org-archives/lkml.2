Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab1ESSKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:10:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167Ab1ESSKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:10:03 -0400
Date: Thu, 19 May 2011 20:09:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rao, Nikhil" <nikhil.rao@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  x86: Removing unnecessary check in detect_ht
Message-ID: <20110519180940.GD6139@elte.hu>
References: <43F901BD926A4E43B106BF17856F0755018E1CF482@orsmsx508.amr.corp.intel.com>
 <4FF5AC937153B0459463C1A88EB478F2010DFD3D3F@orsmsx505.amr.corp.intel.com>
 <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
 <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
 <20110518210754.GA28476@elte.hu>
 <1F668163772FA946975B9466A9DFF729B6A3@ORSMSX101.amr.corp.intel.com>
 <20110518212351.GE28476@elte.hu>
 <1F668163772FA946975B9466A9DFF729B7E4@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1F668163772FA946975B9466A9DFF729B7E4@ORSMSX101.amr.corp.intel.com>
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

> Hi Ingo,
> 
> Reposting as per your feedback.

Please send a patch that applies to the x86 tree cleanly:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
