Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2ACKvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 05:51:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab2ACKvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 05:51:17 -0500
Date: Tue, 3 Jan 2012 11:51:07 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20120103105107.GB3391@redhat.com>
References: <20110902233806.GA22157@elie>
 <20110905091918.GC2221@redhat.com>
 <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
 <20110908084913.GB2195@redhat.com>
 <1321228952.3362.15.camel@fermat.scientia.net>
 <20111114014615.GC16508@elie.hsd1.il.comcast.net>
 <1321466933.3364.16.camel@fermat.scientia.net>
 <20111118074552.GB2203@redhat.com>
 <1325171851.3907.33.camel@fermat.scientia.net>
 <20111229201149.GB1674@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111229201149.GB1674@elie.Belkin>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 02:11:49PM -0600, Jonathan Nieder wrote:
> Christoph Anton Mitterer wrote:
> 
> > The logging is basically identical to what I've send before.
> >
> > So either there is some weird hardware damage,.. or (as I suggested
> > before) it might be just some different revision or so of the chipset,
> > behaving different?!

Hmm, on my experience, software sucks much more than hardware, but we
never can exclude hardware problem. I'm not sure if there are divergence
between iwl4965 chipsets. Also I'm not sure if there are more than one
chipsets revision at all. Christoph, you mentioned that you replaced you 
motherboard. Did the problem start to happen after that? Did you
correctly connect antennas cables to adapter. Does adapter sits
tight in the mini PCIe slot?

> > Guess it's pointless to send you the same logging output again, but if
> > you'd like to I can do so.
> 
> Yes, please do, or provide a link and summary so we don't have to hunt
> it down.

No, that's not needed if there are no good logs for compare. If possible
try on some very old kernel, first kernel with iwl4965 support was 2.6.24.

Thanks
Stanislaw
