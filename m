Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab0FBXcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:32:08 -0400
Received: from mail.perches.com ([173.55.12.10]:2612 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161Ab0FBXcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:32:05 -0400
Subject: Re: [B.A.T.M.A.N.] [PATCH] drivers/staging/batman-adv: Convert
 MAC_FMT to %pM
From: Joe Perches <joe@perches.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel <devel@driverdev.osuosl.org>,
       Andrew Lunn <andrew@lunn.ch>, b.a.t.m.a.n@lists.open-mesh.net,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Marek Lindner <lindner_marek@yahoo.de>
In-Reply-To: <201006030123.25027.sven.eckelmann@gmx.de>
References: <1275509418.23599.42.camel@Joe-Laptop.home>
	 <201006030123.25027.sven.eckelmann@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 16:32:02 -0700
Message-ID: <1275521522.23599.88.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 01:23 +0200, Sven Eckelmann wrote:
> You've also changed the output. So you may partly broke batctl too (have to 
> check that first).

There was no change in output.
MAC_FMT output is the same as %pM

cheers, Joe

