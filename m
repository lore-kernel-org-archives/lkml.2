Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1GGAd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:33:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab1GGAdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:33:55 -0400
Date: Wed, 6 Jul 2011 17:33:38 -0700
From: Greg KH <gregkh@suse.de>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: axboe@kernel.dk, kay.sievers@vrfy.org,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.38.8] Bisected to commit
 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09
Message-ID: <20110707003338.GA25302@suse.de>
References: <4E11BAE0.5020208@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E11BAE0.5020208@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 03:06:40PM +0200, Knut Petersen wrote:
> Hi everybody!
> 
> An openSuse 11.2 system reliably refused to boot properly with kernel 2.6.38.8
> although the prior 2.6.38.y kernels worked fine.  After a few seconds booting
> stopped. Several <ctrl-c> did help, but a lot of services were not started properly,
> only the root partition was available. Nothing unusual could be found in the
> kernel messages.
> 
> I bisected the problem to commit 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09.
> 
> That gave me the idea to disconnect the Plextor PX-755A dvd drive  and to
> try 2.6.38.8 again. It booted without problem.

Does the 2.6.39.2 kernel work properly for you?
