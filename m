Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LJVRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:17:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2LJVRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:17:05 -0500
Date: Mon, 10 Dec 2012 18:16:50 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: Fix irqfd resampler list walk
Message-ID: <20121210201650.GA2402@amt.cnet>
References: <20121206214355.24853.71852.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206214355.24853.71852.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 02:44:59PM -0700, Alex Williamson wrote:
> Typo for the next pointer means we're walking random data here.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org [3.7]
> ---
> 
> Not sure if this will make 3.7, so preemptively adding the stable flag
> 
>  virt/kvm/eventfd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

