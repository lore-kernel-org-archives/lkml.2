Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1K1Onl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:43:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:57186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1K1Onk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:43:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="80476003"
Message-ID: <4ED39E17.7050807@linux.intel.com>
Date: Mon, 28 Nov 2011 06:43:35 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        paulus@samba.org, mingo@elte.hu, asharma@fb.com, devel@openvz.org,
        dsahern@gmail.com, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 7/7] event: add tracepoint for accounting block time
References: <1322471015-107825-1-git-send-email-avagin@openvz.org> <1322471015-107825-8-git-send-email-avagin@openvz.org> <1322480531.2921.107.camel@twins> <4ED39473.9080600@linux.intel.com> <20111128143140.GA12377@infradead.org>
In-Reply-To: <20111128143140.GA12377@infradead.org>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> perf_evlist is what you call perf_bundle and perf_evsel is what you call
> perf_event in powertop.
> 
> That part of the API should be ok for wider use and is in fact exported
> in the python binding.

I don't care about the snake language.

frankly all that's missing is a "safe" accessor library as Steve has
promised will appear.

that library really needs to be a proper shared library and not come
from/with the kernel package, so that distributions can independently
package it properly.
(and this obviously needs to at least look at the things that the
systemd guys pointed us at at the kernel summit)

I'm not interested if the code for a library is somewhere deep in the
kernel source code, not installed by default in distros (or tied in with
loads of other mess) and/or uses the kernel makefiles/etc like perf does.


