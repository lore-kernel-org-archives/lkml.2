Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab0JHWsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:48:18 -0400
Received: from mail.sdinet.de ([78.47.32.153]:44920 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0JHWsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:48:16 -0400
Date: Sat, 9 Oct 2010 00:47:37 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: Suraj Sumangala <Suraj.Sumangala@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or replace
 ath3k-1.fw ?
In-Reply-To: <20101008181508.GM10149@tux>
Message-ID: <alpine.DEB.2.02.1010090040240.19472@aurora.sdinet.de>
References: <20101008170258.GJ10149@tux> <4CAF5488.3030706@Atheros.com> <20101008181508.GM10149@tux>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Luis R. Rodriguez wrote:

> > > I last tried to document a thread we had over this here:
> > >
> > > http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> > >
> 
> Thanks, I've updated that link above to document bug fixing does not require
> a filename change.

I would summarize it as:

If a new firmware version also works with an old driver, keep the filename.

If a new firmware version also requires a new driver, change the name.

If a new driver requires a new firmware, change the name.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
