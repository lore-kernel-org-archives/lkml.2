Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2LUJEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:04:53 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:46625 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab2LUJEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:04:40 -0500
Message-ID: <50D42626.40708@msgid.tls.msk.ru>
Date: Fri, 21 Dec 2012 13:04:38 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.10) Gecko/20121028 Icedove/10.0.10
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v4 00/11] x86/microcode: Early load microcode
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.12.2012 23:48, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> The problem in current microcode loading method is that we load a microcode way,
> way too late; ideally we should load it before turning paging on.  This may only
> be practical on 32 bits since we can't get to 64-bit mode without paging on,
> but we should still do it as early as at all possible.

Why loading microcode this early is important?
Why it is bad to load it at the end of (initial) boot?

Thanks,

/mjt
