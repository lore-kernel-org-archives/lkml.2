Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1KIVIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:08:46 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:45195 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1KIVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:08:44 -0500
Subject: Re: [PATCH] net: drivers/net/hippi/Kconfig should be sourced
From: Paul Bolle <pebolle@tiscali.nl>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com
In-Reply-To: <20111109.154643.2008804116058722848.davem@davemloft.net>
References: <1320784270.14409.404.camel@x61.thuisdomein>
	 <20111109.154643.2008804116058722848.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 22:08:36 +0100
Message-ID: <1320872916.27598.49.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 15:46 -0500, David Miller wrote:
> Please at least type "make oldconfig" with CONFIG_HIPPI enabled or
> similar before submitting patches like this.
> 
> There is nothing architecture or platform specific about getting
> the option enabled enough for you to see this:
> 
> drivers/net/hippi/Kconfig:40: syntax error
> drivers/net/hippi/Kconfig:20: missing end statement for this entry
> drivers/net/Kconfig:28: missing end statement for this entry
> drivers/Kconfig:1: missing end statement for this entry
> drivers/net/hippi/Kconfig:39: invalid statement
> drivers/net/Kconfig:341: unexpected end statement
> drivers/Kconfig:139: unexpected end statement
> make[1]: *** [oldconfig] Error 1
> make: *** [oldconfig] Error 2
> 
> I've fixed this up but if you can't be bothered to type "make" I
> seriously can't be bothered to even look at your patch submissions.

Would it be better if I hadn't submitted this as a patch (with a
warning, which you perhaps missed, that I didn't build test it) but as a
simple message to notify the people who wrote the patch that started all
this, netdev and you, that that commit was incomplete? If so, I'd be
glad to only do that in the future.


Paul Bolle

