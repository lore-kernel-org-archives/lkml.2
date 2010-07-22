Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0GVAPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0GVAPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:15:06 -0400
Date: Thu, 22 Jul 2010 10:13:55 +1000
From: Dave Chinner <dchinner@redhat.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] SUNRPC auth: add context argument to shrinker callback
Message-ID: <20100722001355.GB31881@devil>
References: <1279698095-17287-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279698095-17287-1-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 09:41:35AM +0200, Marc Kleine-Budde wrote:
> Hello,
> 
> I found this regression in the current mainline tree.

The fix is already in Linus' current git tree (commit
567c7b0edec0200c5c6613f07c3d3b4034fdc836 ("mm: add context argument to
shrinker callback to remaining shrinkers"). Thanks for catching
it, anyway.

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com
