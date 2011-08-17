Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1HQSh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:37:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1HQShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:37:24 -0400
Date: Wed, 17 Aug 2011 20:37:22 +0200
From: Jan Kara <jack@suse.cz>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] [KORG] Taking hera down to deal with the
 load issues
Message-ID: <20110817183722.GH9959@quack.suse.cz>
References: <4E4AFCFC.9020008@kernel.org>
 <4E4B7664.9070301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4B7664.9070301@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Wed 17-08-11 01:05:56, J.H. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> This second kernel is at least, so far, acting a lot closer to what I'd
> expect from hera, but the disk cache is still filling.  I'm going to
> keep an eye on it for a bit longer tonight.  As a note, the only
> difference between the first 3.1-rc1 kernel and the second, that is
> currently running, was the explicit disabling of IMA and recompiling the
> kernel.
  What do you exactly mean by "disk cache is still filling"? 3.1-rc1 has
quite some changes in writeback code so it's possible something went
wrong...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
