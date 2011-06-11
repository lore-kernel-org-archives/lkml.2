Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab1FKU5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 16:57:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1FKU5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 16:57:20 -0400
Date: Sat, 11 Jun 2011 13:57:07 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/8] PM / Domains: Support for generic I/O PM domains (v5)
Message-ID: <20110611205707.GB15267@suse.de>
References: <201106112223.04972.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106112223.04972.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 10:23:04PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> This is the 4th update of the patchset adding support for generic I/O PM
> domains.  The patches have been reworked quite a bit to take feedback into
> account, but I left the Greg's ACK in [4/8] in the hope it still applies
> (Greg, please let me know in case it doesn't :-)).

It still applies, thanks for leaving it in.
