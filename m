Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1HHRtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:49:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:33501 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1HHRtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:49:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,338,1309762800"; 
   d="scan'208";a="36476073"
Subject: Re: [patch] x86, x2apic: enable the bios request for x2apic optout
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Prarit Bhargava <prarit@redhat.com>, "trenn@suse.de" <trenn@suse.de>,
        Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20110806070019.GG13220@elte.hu>
References: <1311987173.12777.7.camel@sbsiddha-mobl2>
	 <1312067391.22074.58.camel@i7.infradead.org>
	 <1312167661.17578.4.camel@sbsiddha-mobl2>  <20110806070019.GG13220@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 08 Aug 2011 10:48:29 -0700
Message-Id: <1312825709.17892.19.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 00:00 -0700, Ingo Molnar wrote:
> Guys, mind doing this on top of the DMAR cleanup patches Yinghai 
> posted? (if those patches are fine - i have not checked them in 
> detail yet)

Ingo, I don't think Yinghai has posted the cleanup patches that you were
requesting here http://marc.info/?l=linux-pci&m=131157843015411&w=2.

or Did I miss those patches Yinghai?

thanks,
suresh

