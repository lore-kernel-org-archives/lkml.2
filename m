Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2KZXrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:47:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:39229 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab2KZXrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:47:31 -0500
Date: Mon, 26 Nov 2012 15:47:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP
Message-ID: <20121126234729.GA19416@kroah.com>
References: <1353501740-25420-1-git-send-email-hdoyu@nvidia.com>
 <50B3C426.4020605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B3C426.4020605@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 12:33:58PM -0700, Stephen Warren wrote:
> On 11/21/2012 05:42 AM, Hiroshi Doyu wrote:
> > Fix build warning w/o PM_SLEEP.
> 
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> 
> I assume Greg will take this through his tree.

If so, someone better resend it...

> > Change-Id: I713f7dd697f1ad9fb1fee56b389b0d6c45bb540c
> 
> But that shouldn't be there though...

Agreed, that's not ok.
