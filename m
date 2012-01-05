Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2AEKOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 05:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab2AEKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 05:14:22 -0500
Date: Thu, 5 Jan 2012 11:14:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20120105101412.GB2103@redhat.com>
References: <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
 <20110908084913.GB2195@redhat.com>
 <1321228952.3362.15.camel@fermat.scientia.net>
 <20111114014615.GC16508@elie.hsd1.il.comcast.net>
 <1321466933.3364.16.camel@fermat.scientia.net>
 <20111118074552.GB2203@redhat.com>
 <1325171851.3907.33.camel@fermat.scientia.net>
 <20111229201149.GB1674@elie.Belkin>
 <20120103105107.GB3391@redhat.com>
 <1325640148.3359.142.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325640148.3359.142.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 02:22:28AM +0100, Christoph Anton Mitterer wrote:
> > Christoph, you mentioned that you replaced you 
> > motherboard. Did the problem start to happen after that?
> Yep,... the old board broke (and the system didn't bot anymore at
> all)... it was replaced with a new one by the manufacturer... and
> starting with that (with no software change on the disk in the meantime)
> the wifi didn't work anymore (as described).
Hmm, perhaps iwl4965 device does not work well with the new PCIe chipset.

Does any of fallowing workaround the problem?

kernel boot parameter:
pcie_aspm=off
pci_aspm=force
pci=nocrs
pci=use_crs

iwlegacy module parameter:
bt_coex_active=0

iwl4965 module parameters
11n_disable=1

> > Did you
> > correctly connect antennas cables to adapter.
> yep... at first (when they sent it back to me) it was not connected at
> all... I connected it... the problem persists in both states, connected
> and unconnected.
There should be 3 or 2 antennas: 1 - white, 3 - grey, 2 - black,
connection on adapter should match cable color (ok, I don't know if
it does any difference, but it worth to try). If there is only one
antenna available, perhaps there is somewhere another miniPCIe slot
where are more antenna cables available. But, if there is really
only one antenna cable, it should be connected to number 1 (white)
adapter connector.

Stanislaw

