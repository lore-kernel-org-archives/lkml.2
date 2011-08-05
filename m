Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1HES1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:27:10 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43392 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab1HES1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:27:07 -0400
X-Sasl-enc: e2Z0NEkScFdnfkMCPaJle6mtE81j3JW6c3fJynXq2Zz+ 1312568826
Date: Fri, 5 Aug 2011 11:19:04 -0700
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Please backport c2419b4a4727f67af2fc2cd68b0d878b75e781bb (xen:
 allow enable use of VGA console on dom0) in 3.0, 2.6.39, 2.6.38 and 2.6.37
Message-ID: <20110805181904.GA22071@kroah.com>
References: <20110726163006.GA5592@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726163006.GA5592@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 12:30:06PM -0400, Konrad Rzeszutek Wilk wrote:
> The "xen: allow enable use of VGA console on dom0" has been pulled by Linus
> in 3.1. I've forgotten to stick the CC: stable@kernel.org on the patch so
> doing this by hand.
> 
> Please backport the upstream commit c2419b4a4727f67af2fc2cd68b0d878b75e781bb
> in 3.0, 2.6.39, 2.6.38 and 2.6.37 trees. The older trees do not need it.

As only 3.0 is in active support right now, I've applied it there.

greg k-h
