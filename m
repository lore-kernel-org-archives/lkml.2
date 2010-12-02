Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0LBI0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:26:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:13438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0LBI0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:26:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208";a="863473272"
Subject: Re: [RFC] persistent store (version 2) (part 1 of 2)
From: Huang Ying <ying.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
References: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 16:26:07 +0800
Message-ID: <1291278367.12648.567.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tony,

On Wed, 2010-12-01 at 08:20 +0800, Luck, Tony wrote:
> +struct pstore_info {
> +	unsigned long	header_size;
> +	unsigned long	data_size;
> +	unsigned long	footer_size;
> +	int	(*reader)(u64 *id, int *type, void *buf, unsigned long *size);
> +	int	(*writer)(int type, void *buf, unsigned long size);
> +	int	(*eraser)(u64 id);
> +};

How about rename these 3 functions to read, write and erase?

Best Regards,
Huang Ying


