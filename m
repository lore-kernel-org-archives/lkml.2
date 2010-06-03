Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab0FCAUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:20:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2633 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349Ab0FCAUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:20:03 -0400
Subject: Re: [B.A.T.M.A.N.] [PATCH] drivers/staging/batman-adv: Convert
 MAC_FMT to %pM
From: Joe Perches <joe@perches.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel <devel@driverdev.osuosl.org>,
       Andrew Lunn <andrew@lunn.ch>, b.a.t.m.a.n@lists.open-mesh.net,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Marek Lindner <lindner_marek@yahoo.de>
In-Reply-To: <201006030156.42370.sven.eckelmann@gmx.de>
References: <1275509418.23599.42.camel@Joe-Laptop.home>
	 <201006030133.25522.sven.eckelmann@gmx.de>
	 <1275522450.23599.101.camel@Joe-Laptop.home>
	 <201006030156.42370.sven.eckelmann@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 17:20:01 -0700
Message-ID: <1275524401.23599.116.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 01:56 +0200, Sven Eckelmann wrote:
> see sys.c -> log_print
> and read_file -> read_file

Yuck.

The patch changes the prefix from "batman-adv:" to "batman_adv: "
so yes, it would break as-is.

I think the concept is broken though, I believe dmesg output
specifically is not guaranteed to remain stable, and batman should
use some other, perhaps private, logger based on ethtool events.

cheers, Joe

