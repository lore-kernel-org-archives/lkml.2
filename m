Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2ICNRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:17:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab2ICNRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:17:11 -0400
Date: Mon, 3 Sep 2012 15:17:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/20] HID: Only dump input if someone is listening
In-Reply-To: <20120902085211.GA604@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1209031515450.20709@pobox.suse.cz>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se> <1346528835-363-17-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1209020927130.20709@pobox.suse.cz> <20120902085211.GA604@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2012, Henrik Rydberg wrote:

> > I have applied this one right away, so you can drop it from your series. 
> > The remaining ones I am still about to review (currently travelling).
> 
> Great, thanks. The notification callback can also be applied if you want.
> 
> > There is no inter-dependency between the Input and HID ones, and so we can 
> > handle them with Dmitry as two independent Input and HID series, right?
> 
> Not quite, I am afraid. Some of the overlap has disappeared, true.
> However, the hid-multitouch patches depend on new variables defined in
> the input-mt patches, which in turn depend on the input core
> changes. The hid-multitouch patches will apply (with a tiny merge
> conflict), but they will not compile.
> 
> I can split the input-core and hid-core changes into separate sets,
> and those could be applied separately. The input-mt and bcm5974 will
> then build on input-core, and hid-multitouch will build on both
> input-core and hid-core. I am not sure if this helps anyone, though.

I don't think so.

Let's wait once Dmitry is finished with the input changes, and I can 
either take the set through my tree with his Signed-off-by: on the Input 
patches, or vice-versa.

Thanks,

-- 
Jiri Kosina
SUSE Labs
