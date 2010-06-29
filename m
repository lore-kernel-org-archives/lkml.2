Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0F2M54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:57:56 -0400
Received: from kroah.org ([198.145.64.141]:57237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0F2M5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:57:54 -0400
Date: Tue, 29 Jun 2010 05:54:22 -0700
From: Greg KH <greg@kroah.com>
To: Michal Marek <mmarek@suse.cz>
Cc: stable@kernel.org, Alan <alan@clueserver.org>,
       linux-kernel@vger.kernel.org,
       Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khc@pm.waw.pl>
Subject: Re: [stable] [PATCH for stable] kbuild: Fix modpost segfault
Message-ID: <20100629125422.GB29243@kroah.com>
References: <20100629094341.GA26045@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629094341.GA26045@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:43:42AM +0200, Michal Marek wrote:
> Hi Greg,
> 
> please add this to stable, it's a bug that started showing up with newer
> gcc. The upstream commit is 1c938663d58b5b2965976a6f54cc51b5d6f691aa.

What -stable kernels do you want it applied to?  .27, .32, .33, and/or
.34?

thanks,

greg k-h
