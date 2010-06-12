Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0FLI3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 04:29:25 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:40299 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0FLI3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 04:29:23 -0400
Date: Sat, 12 Jun 2010 10:29:19 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Alexander Clouter <alex@digriz.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
Message-ID: <20100612082919.GN1743@mail.wantstofly.org>
References: <4c1139ba.0d01df0a.42a6.1368@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c1139ba.0d01df0a.42a6.1368@mx.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 10:12:55PM +0300, Dmytro Milinevskyy wrote:

> This patch adds support for the OpenRD Ultimate machine(could be found at http://www.arm.linux.org.uk/developer/machines/list.php?id=2884)

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>


> +MACHINE_START(OPENRD_ULTIMATE, "Marvell OpenRD Ultimate Board")
> +	/* Maintainer: Dhaval Vasa <dhaval.vasa@einfochips.com> */

I wonder whether this is correct, though.
