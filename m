Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0FIHZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:25:51 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:44774 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0FIHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:25:50 -0400
Date: Wed, 9 Jun 2010 09:25:46 +0200
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
Message-ID: <20100609072546.GB1743@mail.wantstofly.org>
References: <4c0e9ee6.8704df0a.2e71.ffffdf65@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c0e9ee6.8704df0a.2e71.ffffdf65@mx.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:47:47PM +0300, Dmytro Milinevskyy wrote:

> Differences from the previous attempt:
>  - Applied suggestion from Lennert Buytenhek to change PHY addresses in instances of mv643xx_eth_platform_data in case of ultimate version.

The patch looks exactly like the old patch, though?
