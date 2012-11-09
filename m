Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2KITUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:20:13 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:39541 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KITUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:20:10 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuzUAMpWnVBV5h1yPGdsb2JhbABEhTAiAYUAt2wBAQGBABkBAQEBHxkNJ4IeAQEFOhwjEAgDGC4UJQoaE4gOvg0UjAB9VYEdgnphA5V6hXuDTolr
X-IronPort-AV: E=Sophos;i="4.80,747,1344204000"; 
   d="scan'208";a="446653383"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 9 Nov 2012 20:26:04 +0100
To: Alexandra Chin <Alexandra.Chin@tw.synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH v5] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121109192604.GA16972@polaris.bitmath.org>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121108150529.b16707c1c84e6fd862e58b6a@tw.synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108150529.b16707c1c84e6fd862e58b6a@tw.synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 03:05:29PM +0800, Alexandra Chin wrote:
> Convert to MT-B because Synaptics touch devices are capable
> of tracking identifiable fingers.
> 
> Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
> ---
> Changes from v5:
>         - Incorporated Henrik's review comments
>           *rollback to v3 from v4
>           *fix odd line break in v3
>         - Include Alexandra in the list of authors

I am seeing _new_ irrelevant changes in this version... There is no
need to revert to v3. Just remove the synaptics_rmi4_query_function()
changes and other uneeded cruft from the v4 patch. No new changes,
please, and make sure the final patch is tested.

Thanks.
Henrik
