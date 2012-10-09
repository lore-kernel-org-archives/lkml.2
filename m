Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2JIGHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:07:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:50168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab2JIGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,558,1344236400"; 
   d="scan'208";a="203272869"
Message-ID: <5073BF32.7040003@zytor.com>
Date: Tue, 09 Oct 2012 14:07:46 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make
 xen happy
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 12:39 PM, Yinghai Lu wrote:
> on top of tip/x86/mm2

Hi Yinghai,

This patchset doesn't apply on top of tip:x86/mm2, starting at patch 08/10.

Furthermore, a lot of the descriptions are both incomplete and
incomprehensible, which makes the patchset very very hard to review.

You should think of the descriptions as writing a (short) paper on your
patchset, where you describe not just what you are doing, but how you
accomplish the objective and why that objective is the right thing do
accomplish.

Overall, this patchset seems to be going in the right direction, but I
have several concerns with details.

	-hpa

