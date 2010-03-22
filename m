Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0CVWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:22:23 -0400
Received: from waste.org ([173.11.57.241]:54131 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab0CVWWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:22:21 -0400
Subject: Re: [Patch v2] netpoll: warn when there are spaces in parameters
From: Matt Mackall <mpm@selenic.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, elendil@planet.nl,
       David Miller <davem@davemloft.net>
In-Reply-To: <20100322090341.5289.10770.sendpatchset@localhost.localdomain>
References: <20100322090341.5289.10770.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 17:22:15 -0500
Message-ID: <1269296535.3552.10.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 04:59 -0400, Amerigo Wang wrote:
> +			printk(KERN_INFO "%s: warning: whitespace"
> +					"is not allowed\n", np->name);

Is it a warning or is it info? If it's a warning, then we probably need
to add "netpoll" or whatever to the message so that people who've got a
warning-level threshold will know what it's about.

-- 
http://selenic.com : development and support for Mercurial and Linux


