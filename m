Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2KEC7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:59:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:32452 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2KEC7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:59:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,712,1344236400"; 
   d="scan'208";a="164481239"
Message-ID: <50972B94.7020106@zytor.com>
Date: Mon, 05 Nov 2012 03:59:32 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Zhang, Jun" <jun.zhang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crash dump: don't delete non-E820_RAM during init
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com> <50909120.3040101@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com> <5090AB3C.5050405@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EB3A@SHSMSX102.ccr.corp.intel.com> <5090B966.4040605@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com> <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com> <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com> <5093F6DA.7040709@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7F4B6@SHSMSX102.ccr.corp.intel.com> <509726D0.4010606@zytor.com> <88DC34334CA3444C85D647DBFA962C270FD7F507@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7F507@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 03:57 AM, Zhang, Jun wrote:
> Hello, Anvin
> 1) use "memmap=exactmap", which remove all ranges include ram and non-ram range. So my first patch reserve the non-ram range.
> 2)don't use " memmap=exactmap ", so it reserve all ranges. But we only need non-ram, so we need kernel to remove RAM, just as my second patch.

Sorry, you have completely lost me now.  You seem to be contradicting
yourself from one message to another.

	-hpa


