Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1HBBJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:09:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:3893 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1HBBJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,303,1309762800"; 
   d="scan'208";a="34751440"
Subject: Re: questions about memory hotplug
From: Shaohua Li <shaohua.li@intel.com>
To: Larry Bassel <lbassel@codeaurora.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110801170850.GB3466@labbmf-linux.qualcomm.com>
References: <20110729221230.GA3466@labbmf-linux.qualcomm.com>
	 <20110730093055.GA10672@sli10-conroe.sh.intel.com>
	 <20110801170850.GB3466@labbmf-linux.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Aug 2011 09:09:36 +0800
Message-ID: <1312247376.15392.454.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-02 at 01:08 +0800, Larry Bassel wrote:
> 
> In use case #1 yes, maybe not in #2 (we can arrange it to be
> at the end of memory, but then might waste memory as it may
> not be aligned on a SPARSEMEM section boundary and so would
> need to be padded).
then maybe the new migrate type I suggested can help here for the
non-aligned memory. Anyway, let me do an experiment.

Thanks,
Shaohua

