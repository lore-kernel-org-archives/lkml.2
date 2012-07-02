Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab2GBJcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:32:47 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1888 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932692Ab2GBJcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:32:45 -0400
Message-ID: <1341221563.1911.141.camel@x61.thuisdomein>
Subject: Re: [PATCH] iwlegacy: print how long queue was actually stuck
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 11:32:43 +0200
In-Reply-To: <20120702090602.GA8286@redhat.com>
References: <1340786187.1911.24.camel@x61.thuisdomein>
	 <1341062406.1911.76.camel@x61.thuisdomein>
	 <20120702090602.GA8286@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 02 Jul 2012 09:32:43.0493 (UTC) FILETIME=[A1D0A950:01CD5835]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 11:06 +0200, Stanislaw Gruszka wrote:
> On Sat, Jun 30, 2012 at 03:20:06PM +0200, Paul Bolle wrote:
> For some reason we are not able to authenticate, what itself is a
> problem. Maybe this is wrong key offset problem and that will
> be fixed by Emmanuel patch.

Which I can only try if we fix the small problem you mentioned in your
comment on Emmanuel's patch (reference
<20120702082653.GA2479@redhat.com>, not yet archived on lkml.org), can't
I?

> Regarding "Queue 2 stuck", there is another fix in iwlwifi that
> did not make to iwlegacy, which perhaps could help. If not here
> then maybe on suspend.  
> 
> commit 342bbf3fee2fa9a18147e74b2e3c4229a4564912
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Sun Mar 4 08:50:46 2012 -0800
> 
>     iwlwifi: always monitor for stuck queues
> 
> I'm attaching iwlegacy version of it.

Thanks, I'll try it. The explanation of the iwlwifi commit makes a lot
of sense: it seems to match the events found in the logs of this laptop.
That's encouraging. Should I report whether the iwlegacy version works
or not?

> > 2) It's always "Queue 2" that's stuck. What does that queue do?
> 
> It's TX queue, probably one used for default traffic i.e. for Best
> Effort category (others are Video, Voice and Background).

I see.

Any thoughts on my patch (ie, the patch that is actually the subject of
this thread?


Paul Bolle

