Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1LFTVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:21:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:56099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1LFTVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:21:14 -0500
Message-ID: <1323199215.32012.87.camel@twins>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken
 branches (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "ravitillo@lbl.gov" <ravitillo@lbl.gov>,
        "paulus@samba.org" <paulus@samba.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>
Date: Tue, 06 Dec 2011 20:20:15 +0100
In-Reply-To: <CABPqkBQq=ra+-O==qT+8DtFZ5T7=M4yJrnPJ_bb+UmUTGGQepQ@mail.gmail.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1323124766.32012.49.camel@twins>
	 <20111206094927.GA25782@mudshark.cambridge.arm.com>
	 <1323169412.32012.69.camel@twins>
	 <CABPqkBQq=ra+-O==qT+8DtFZ5T7=M4yJrnPJ_bb+UmUTGGQepQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 11:14 -0800, Stephane Eranian wrote:

> >> > Other than the few comments given it all looks good. My main worry is
> >> > the Intel only aspect, I'd really love for there to be another platform
> >> > that could implement at least part of this.

> There is a hardware branch buffer on all Itanium processors.
> You can find the description for the McKinley implementation
>  (Itanium2) branch buffer in section 10.3.9 from:
> http://download.intel.com/design/Itanium2/manuals/25111003.pdf


Yeah, I knew Itanic has it, but one its sinking (and doesn't have perf
support), and two its still Intel ;-)


