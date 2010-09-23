Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0IWQm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:42:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:64430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab0IWQm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,224,1283756400"; 
   d="scan'208";a="660428046"
Date: Thu, 23 Sep 2010 16:55:55 +0100
From: Alan Cox <alan@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923165555.7f26127d@linux.intel.com>
In-Reply-To: <20100923144606.GH25663@rakim.wolfsonmicro.main>
References: <20100922231514.5e9967c7@linux.intel.com>
	<20100923060703.GB11198@angua.secretlab.ca>
	<20100923095411.GA25663@rakim.wolfsonmicro.main>
	<20100923112703.543b0b86@lxorguk.ukuu.org.uk>
	<20100923102708.GC25663@rakim.wolfsonmicro.main>
	<20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
	<20100923105208.GD25663@rakim.wolfsonmicro.main>
	<20100923111347.0cf93bb3@linux.intel.com>
	<20100923141133.GG25663@rakim.wolfsonmicro.main>
	<20100923142720.13bf9d69@linux.intel.com>
	<20100923144606.GH25663@rakim.wolfsonmicro.main>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> usually what causes things to break down.  However, if you're totally
> confident that all the BIOS authors at the OEMs are going to work
> well together here then I guess it's only Moorestown that's affected.

I'm not 100% confident which is why we lobbied hard to get DMI into the
firmware, but I think there is a good chance the SFI stuff will be
fine. My bigger worry to be honest is going to be people adding stuff
which isn't even in firmware enumerations.

