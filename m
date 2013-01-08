Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab3AHTsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:48:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab3AHTsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:48:20 -0500
Message-ID: <50EC77DB.6090300@zytor.com>
Date: Tue, 08 Jan 2013 11:47:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v5 00/12] x86/microcode: Early load microcode
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com> <20130103174455.GA7350@localhost.localdomain> <50E5C47B.6060707@zytor.com> <20130108194633.GA15194@phenom.dumpdata.com>
In-Reply-To: <20130108194633.GA15194@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 11:46 AM, Konrad Rzeszutek Wilk wrote:
> 
> OK. I am trying to figure out whether this usage of native_* for the
> MSRs was done on purpose - and it sounds like the answer is no. If so -
> can it be done using the normal 'safe_rdmsr' and 'wrmsr'?
> 
> That would allow at least in the case of Xen, to omit a whole bunch
> of MSR writes/reads during the boot that are not neccessary as we would
> not trap in the hypervisor - but could use the pvops version of
> read/write MSR calls to just do a nop.
> 

Why is this code invoked on Xen at all?  That seems crazy.

	-hpa


