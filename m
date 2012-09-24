Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2IXGwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:52:47 -0400
Received: from gw1.zacglen.com ([220.233.85.112]:38071 "EHLO zacglen.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753023Ab2IXGwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:52:47 -0400
Date: Mon, 24 Sep 2012 16:52:32 +1000
Message-Id: <201209240652.q8O6qWGf012411.zacglen.com@localhost>
To: dan.carpenter@oracle.com
Subject: Re: Freeze or Oops on recent kernels
From: yvahk-xreary@zacglen.net
Cc: dheitmueller@kernellabs.com, linux-kernel@vger.kernel.org,
        mijhail.moreyra@gmail.com, stoth@kernellabs.com
In-Reply-To: <20120924063641.GB28937@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>HINT: We only care about the very most recent kernel.  If you can
>take a photo of the stack trace, then file a bug report and attach
>the .jpg.
>

After a bit of experimentation my guess is that is is all
about bad Intel DX58SO2 motherboard.

And my guess is that it has something to do with memory
mapping during an interrupt. Don't know much about memory
mapping but I suspect that something quite fundamental
goes wrong with this motherboard only.

Exact same type of oops also happens with a PCIe RS232 serial card.

Trouble is that one tends to select hardware for stability so that
means slightly older hardware and hopefully fewer bugs.
Unfortunately latest hardware may not be supported by older
more stable kernels, and it also wont be well supported by newer
kernels.

Worse still, everything lasts less than a year with manufacturers getting
away with vandalistic change of sockets or connectors or chipsets just to
achieve more sales, and new bugs. This constant cycle of pointless
change doesn't seem to be heading anywhere in particular.

John W

