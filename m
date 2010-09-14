Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0INHsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:48:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0INHsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:48:20 -0400
Date: Tue, 14 Sep 2010 09:48:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Valdis.Kletnieks@vt.edu
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100914094813.2601eb86@basil.nowhere.org>
In-Reply-To: <74508.1284413121@localhost>
References: <20100910184039.GK4879@redhat.com>
	<1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
	<20100913141140.GB27371@redhat.com>
	<20100913172438.37443bf7@basil.nowhere.org>
	<20100913154750.GA26290@redhat.com>
	<20100913185721.59ad9b4d@basil.nowhere.org>
	<20100913175346.GC26290@redhat.com>
	<20100913200707.3b31429e@basil.nowhere.org>
	<20100913182354.GE26290@redhat.com>
	<20100913203654.26724055@basil.nowhere.org>
	<20100913193655.GF26290@redhat.com>
	<20100913224952.442d7a24@basil.nowhere.org>
	<74508.1284413121@localhost>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 17:25:21 -0400
Valdis.Kletnieks@vt.edu wrote:

> > Practically every PC has a small amount of NVRAM.
> 
> The big question is how much NVRAM the PC has that is safe for our
> NMI code to hijack/borrow across the reboot without scrogging
> something that the BIOS has squirreled away in there. I recall one
> patch that saved progress indicators during early boot or something -
> but at the expense of stomping on the saved clock settings or
> whatever so you rebooted and then you knew where your previos boot
> wedged, but your system thought it was 1970 again. 

It's already implemented for MCE and it works on servers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
