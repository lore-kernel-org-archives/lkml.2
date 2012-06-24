Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab2FXQ4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab2FXQ4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:56:46 -0400
Date: Sun, 24 Jun 2012 17:55:55 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org, Joe Thornber <dm-devel@redhat.com>,
        linux-next@vger.kernel.org, akpm@linux-foundation.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] mmotm 2012-06-21-16-20 uploaded (dm-thin)
Message-ID: <20120624165555.GA17647@agk-dp.fab.redhat.com>
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Joe Thornber <dm-devel@redhat.com>, linux-next@vger.kernel.org,
	akpm@linux-foundation.org, Alasdair Kergon <agk@redhat.com>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com> <4FE4AAAE.3090803@xenotime.net> <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 12:44:25AM +1000, Stephen Rothwell wrote:
> I assume that CONFIG_LDBAF is not set and I think this is caused by
> commit ebf5d9e0425c ("Non power of 2 blocksize support is needed to
> properly align thinp IO") from the device-mapper tree.
 
Ah yes, I'll fix that, and check we handle "too large" devices sensibly.

Alasdair
