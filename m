Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1CGXIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:08:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab1CGXIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:08:15 -0500
Date: Mon, 7 Mar 2011 15:07:35 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: fix build warnings with CONFIG_PM_SLEEP
 disabled
Message-ID: <20110307150735.3d6515f2@nehalam>
In-Reply-To: <20110307021450.GC31188@google.com>
References: <20110307021450.GC31188@google.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011 18:14:50 -0800
Michel Lespinasse <walken@google.com> wrote:

> This fixes a couple of build warnings when CONFIG_PM is enabled but
> CONFIG_PM_SLEEP is disabled. Applies on top of v2.6.38-rc7 - I know it's
> late, but it would be great if v2.6.38 could compile without warnings!
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

This is standard throughout all the network drivers.
Why just fix 2?


-- 
