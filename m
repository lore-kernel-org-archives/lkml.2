Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1CQMdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:33:21 -0400
Received: from mail.pbcl.net ([88.198.119.4]:50539 "EHLO hetzner.pbcl.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754006Ab1CQMdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:33:19 -0400
X-Greylist: delayed 2786 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 08:33:19 EDT
Subject: Re: [PATCH] econet: 4 byte infoleak to the network
From: Phil Blundell <philb@gnu.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        Nelson Elhage <nelhage@ksplice.com>, netdev@vger.kernel.org
In-Reply-To: <1300362011-8653-1-git-send-email-segoon@openwall.com>
References: <1300362011-8653-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 11:50:01 +0000
Message-ID: <1300362601.2132.14721.camel@phil-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 14:40 +0300, Vasiliy Kulikov wrote:
> struct aunhdr has 4 padding bytes between 'pad' and 'handle' fields on
> x86_64.  These bytes are not initialized in the variable 'ah' before
> sending 'ah' to the network.  This leads to 4 bytes kernel stack
> infoleak.
> 
> This bug was introduced before the git epoch.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Well spotted.  Thanks for the patch.

Acked-by: Phil Blundell <philb@gnu.org>

p.


