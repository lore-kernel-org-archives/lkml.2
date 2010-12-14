Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0LNKsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:48:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38898 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0LNKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:48:11 -0500
Date: Tue, 14 Dec 2010 11:48:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andi Kleen <andi@firstfloor.org>, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [38/223] SUNRPC: After calling xprt_release(), we must
 restart from call_reserve
Message-ID: <20101214104805.GB21257@basil.fritz.box>
References: <201012131244.547034648@firstfloor.org>
 <20101212234534.D3DFCB27BF@basil.firstfloor.org>
 <1292281294.13943.2.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292281294.13943.2.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 06:01:34PM -0500, Trond Myklebust wrote:
> On Mon, 2010-12-13 at 00:45 +0100, Andi Kleen wrote:
> > 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
> 
> Hi Andi,
> 
> This patch isn't strictly needed for kernels 2.6.35.x or older: the Oops
> only appears in 2.6.36.

Dropped. Thanks.
-Andi
