Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1F0RZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:25:04 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:49290 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab1F0RXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:23:08 -0400
Date: Mon, 27 Jun 2011 19:23:05 +0200
From: Bastian Blank <waldi@debian.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH 2/2] xen: Add alias to autoload backend
 drivers
Message-ID: <20110627172305.GC23028@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-devel@lists.xensource.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20110624215155.GB4735@wavehammer.waldi.eu.org>
 <20110627161327.GO6978@dumpdata.com>
 <20110627163728.GA23028@wavehammer.waldi.eu.org>
 <20110627165109.GB13335@dumpdata.com>
 <20110627165711.GA2201@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110627165711.GA2201@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 12:57:11PM -0400, Konrad Rzeszutek Wilk wrote:
> Ugh actually no I can't.

Why? It does not actually change things.

> Can you re-submit these two patches (and stick on Acked-by Ian on them) and
> split the "xen: Add alias to autoload backend driver" in three patches:
>  1) the xen-netback (and copy David Miller)
>  2) the xen-blkback (and copy Jens Axboe)
>  3) the xenbus one

That is silly.

> That should be five patches total.

No, 2+2 is 4, not five.

Bastian

-- 
Each kiss is as the first.
		-- Miramanee, Kirk's wife, "The Paradise Syndrome",
		   stardate 4842.6
