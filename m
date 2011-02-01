Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1BAWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:13:29 -0500
Received: from verein.lst.de ([213.95.11.210]:43719 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1BAWN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:13:28 -0500
Date: Tue, 1 Feb 2011 23:13:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 3/4] hfsplus: Clear volume header pointers on failure
Message-ID: <20110201221313.GA24066@lst.de>
References: <20110201162802.2dd07201@katamari> <20110201164507.3e642bb3@katamari>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201164507.3e642bb3@katamari>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 04:45:07PM -0500, Chuck Ebbert wrote:
> hfsplus: Clear volume header pointers on failure
> 
> The next patch will use NULL volume header to determine whether
> to flush the superblock. Also fix two failure cases so they
> clear the headers before exiting.

Can you resend it without the NULLing out, which is not required
with proper error handling?

