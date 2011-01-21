Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1AUH3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:29:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:35543 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1AUH27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:28:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,356,1291622400"; 
   d="scan'208";a="699089099"
Subject: Re: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight
	cannot be adjusted
From: Zhang Rui <rui.zhang@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110121064614.GA23310@gamma.logic.tuwien.ac.at>
References: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
	 <1295583107.2613.45.camel@edumazet-laptop>
	 <1295583394.2613.47.camel@edumazet-laptop>
	 <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
	 <1295583107.2613.45.camel@edumazet-laptop>
	 <20110121064614.GA23310@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 15:28:25 +0800
Message-ID: <1295594905.1866.749.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

how do you change the backlight? hotkeys?
does changing /sys/class/backlight/acpi_video0/brightness work for you?

thanks,
rui

On Fri, 2011-01-21 at 14:46 +0800, Norbert Preining wrote:
> Hi Eric, hi all
> 
> On Fr, 21 Jan 2011, Eric Dumazet wrote:
> > Maybe this is the problem Linus had to bisect, you could try his patch :
> 
> > Or just pull linux-2.6, since patch is now committed
> > 
> > commit 28e58ee8ce1f0e69c207f747b7b9054b071e328d
> 
> I am now running on top of 8d99641f6c1a so I have this patch included,
> but still see the same problem. Adjustment *before* suspend works,
> afterwards does not.
> 
> Can someone give me a quick notive how to bisect only those commits
> that touch the relevant parts? acpi?
> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> POTT SHRIGLEY (n.)
> Dried remains of a week-old casserole, eaten when extremely drunk at
> two a.m.
> 			--- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


