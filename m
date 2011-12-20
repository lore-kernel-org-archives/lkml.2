Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1LTGyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:54:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:28230 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1LTGyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:54:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104098542"
Subject: Re: [PATCH -v8] x86: Disable x2apic if nox2apic is specified or
 intr-remap can not be enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <A75BCAD09CE00A4280CDD4429D85F1F92621BD7595@orsmsx501.amr.corp.intel.com>
References: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
	 <A75BCAD09CE00A4280CDD4429D85F1F92621BD7595@orsmsx501.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Mon, 19 Dec 2011 22:54:01 -0800
Message-ID: <1324364041.2286.26.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 18:07 -0800, Suresh Siddha wrote:
> b. for nox2apic, as you try to disable x2apic even if the bios has
> enabled it along with interrupt-remapping, this will probably not work
> unless we disable interrupt-remapping.

Looking at the code, this condition should be handled correctly by the
OS by enabling interrupt-remapping in non extended interrupt-mode. So
this case should be ok.

thanks,
suresh

