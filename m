Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0K3AFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:05:39 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:31469 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab0K3AFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:05:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAP7O80x5LcIv/2dsb2JhbACjCnLCT4VHBA
Date: Tue, 30 Nov 2010 11:05:31 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/7] fs: simple fsync race fix
Message-ID: <20101130000531.GC3255@amd>
References: <20101123140610.292941494@kernel.dk>
 <20101123140707.773579845@kernel.dk>
 <20101129145818.GB26076@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129145818.GB26076@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 09:58:18AM -0500, Christoph Hellwig wrote:
> Instead of removing the data sync support here and re-adding it later
> I would recommend moving the enhanced sync_inode_metadata earlier in
> the series.

Well, one is the minimum bug fix, and the other is a proper
improvement for doing metadata. I chose this approach because
it suits stable backports, and bisecting better.

