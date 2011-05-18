Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1ERWDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:03:50 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35787 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab1ERWDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:03:48 -0400
Date: Wed, 18 May 2011 15:03:46 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com
Subject: Re: [PATCH 1/2] forcedeth: make module parameters readable in
 /sys/module
Message-ID: <20110518150346.508d6406@nehalam>
In-Reply-To: <1305753000-14933-1-git-send-email-decot@google.com>
References: <1305753000-14933-1-git-send-email-decot@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 14:09:59 -0700
David Decotigny <decot@google.com> wrote:

> This change allows to publish the values of the module parameters in
> /sys/module.
> 
>

Although this makes more info for developer, it also means more
stuff in sysfs taking more memory and not providing any real value
that can't be found by looking at the /etc/modprobe.d for any parameters
user might have set.

