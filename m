Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1GYKTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:19:12 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53522 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1GYKTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:19:06 -0400
Date: Mon, 25 Jul 2011 14:19:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 0/3] minor cleanups to EFLAGS initialisation in
 ret_from_fork
Message-ID: <20110725101902.GP4362@sun>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:58:03AM +0100, Ian Campbell wrote:
> The following series removes the use of a global kernel_eflags variable
> from the x86_64 ret_from_fork path and (very slightly) merges the 32 and
> 64 bit version of that code path.
> 
> kernel_eflags could be made a __read_mostly but actually there is no
> reason to prefer the value at cpu_init() time to a compile time constant
> value for the initial eflags after a fork.
> 
> Ian.
> 

Thanks, Ian! I think noone against this simplification, Peter, Andi?

	Cyrill
