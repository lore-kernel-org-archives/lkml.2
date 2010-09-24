Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0IXMAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:00:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0IXMAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:00:24 -0400
Date: Fri, 24 Sep 2010 14:00:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Poole <mdpoole@troilus.org>
Cc: linux-input@vger.kernel.org, Chase Douglas <chase.douglas@canonical.com>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: magicmouse: Use hid-input parsing rather than
 bypassing it
In-Reply-To: <1285244139.22958.16.camel@graviton>
Message-ID: <alpine.LNX.2.00.1009241359470.26813@pobox.suse.cz>
References: <1285244139.22958.16.camel@graviton>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Michael Poole wrote:

> Let the HID core handle input device setup and HID-compliant reports.
> This driver then only has to worry about the non-standard reports.

Applied, thanks.

BTW the patch has been line-wrapped. I have fixed it by hand, but please 
keep it in mind for future patch submissions. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
