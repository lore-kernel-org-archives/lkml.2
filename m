Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1LMBgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:36:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:20542 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1LMBgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:36:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85003449"
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Berck E. Nash" <flyboy@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 12 Dec 2011 17:41:15 -0800
In-Reply-To: <CAE9FiQW5GNTqgpFtV1JuOY51H4sUBCwLwJhJqxVtwksCFsdvHQ@mail.gmail.com>
References: <4EE2BC33.80902@gmail.com>
	 <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
	 <20111211075713.GA20790@elte.hu>
	 <CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>
	 <4EE5291C.1030302@gmail.com>
	 <CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
	 <4EE68C80.7000408@gmail.com>
	 <1323735902.1984.165.camel@sbsiddha-desk.sc.intel.com>
	 <CAE9FiQW5GNTqgpFtV1JuOY51H4sUBCwLwJhJqxVtwksCFsdvHQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323740475.1984.171.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 17:29 -0800, Yinghai Lu wrote:
> but i don't think bios buy can go that far to enable intr-remapping
> without providing DMAR.

We never know. And also It is not just bios. kexec'd kernel with out the
interrupt-remapping support will also run into this issue and we should
handle this also gracefully.

thanks,
suresh

