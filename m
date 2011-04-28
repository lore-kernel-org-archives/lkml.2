Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1D1VOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:14:12 -0400
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:35536 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab1D1VOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:14:11 -0400
Subject: Re: [PATCHv3 3/7] ethtool: Use the full 32 bit speed range in
 ethtool's set_settings
From: David Dillow <dave@thedillows.org>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1303954043-17440-4-git-send-email-decot@google.com>
References: <1303954043-17440-1-git-send-email-decot@google.com>
	 <1303954043-17440-4-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 17:14:09 -0400
Message-ID: <1304025249.16087.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 18:27 -0700, David Decotigny wrote:
> This makes sure the ethtool's set_settings() callback of network
> drivers don't ignore the 16 most significant bits when ethtool calls
> their set_settings().
> 
> All drivers compiled with make allyesconfig on x86_64 have been
> updated.
> 
> Tested: make allyesconfig compiles + e1000e and bnx2x work
> Signed-off-by: David Decotigny <decot@google.com>

For what it's worth, the typhoon changes are

Acked-by: David Dillow <dave@thedillows.org>

