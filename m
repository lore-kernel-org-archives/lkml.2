Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1ERVNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:13:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:63540 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1ERVNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:13:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,233,1304319600"; 
   d="scan'208";a="3616582"
From: "Rao, Nikhil" <nikhil.rao@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Topic: [PATCH]  x86: Removing unnecessary check in detect_ht
Thread-Index: AQHMFZ+wwMCJ5f57lUKQ3lDQVr7GwpSTFQXQ
Date: Wed, 18 May 2011 21:13:19 +0000
Message-ID: <1F668163772FA946975B9466A9DFF729B6A3@ORSMSX101.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755018E1CF482@orsmsx508.amr.corp.intel.com>
 <4FF5AC937153B0459463C1A88EB478F2010DFD3D3F@orsmsx505.amr.corp.intel.com>
 <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
 <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
 <20110518210754.GA28476@elte.hu>
In-Reply-To: <20110518210754.GA28476@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.131.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing apart from what you mention - bootlog message and SMP instead of SMT.

Nikhil

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Wednesday, May 18, 2011 2:08 PM
> To: Rao, Nikhil
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org; Siddha, Suresh B; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86: Removing unnecessary check in detect_ht
> 
> 
> * Rao, Nikhil <nikhil.rao@intel.com> wrote:
> 
> > This patch removes a check that prevents correct CPU topology setup
> > when cpuid extensions for topology enumeration are not supported and
> > the number of processors reported to the OS is smaller than
> > smp_num_siblings
> 
> What bad effect was observed, exactly? An annoying warning in the
> bootlog and
> incorrect scheduler domain setup (SMP instead of SMT) - or something
> else as
> well?
> 
> Thanks,
> 
> 	Ingo
