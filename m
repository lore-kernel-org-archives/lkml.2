Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1EILGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:06:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab1EILGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:06:32 -0400
Date: Mon, 9 May 2011 13:06:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] iwl4965: drop a lone pr_err()
Message-ID: <20110509110621.GA2294@redhat.com>
References: <1304771519.2227.6.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304771519.2227.6.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 02:31:59PM +0200, Paul Bolle wrote:
> iwl4965_rate_control_register() prints a message at KERN_ERR level. It
> looks like it's just a debugging message, so pr_err() seems to be
> overdone. But none of the similar functions in drivers/net/wireless
> print a message, so let's just drop it entirely.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Previously sent for (I guess) v2.6.39-rc2. Still present in v2.6.39-rc6.

This patch is already applied in wireless-next ...

commit a22e93f5d819f11d2a2d6332e20ff5b462e5c208
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Thu Apr 7 20:40:32 2011 +0200

    iwl4965: drop a lone pr_err()
    
    iwl4965_rate_control_register() prints a message at KERN_ERR level.
It
    looks like it's just a debugging message, so pr_err() seems to be
    overdone. But none of the similar functions in drivers/net/wireless
    print a message, so let's just drop it.
    
    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

