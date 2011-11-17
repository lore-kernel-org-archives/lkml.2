Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1KQC6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:58:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47934 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1KQC6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:58:43 -0500
Date: Wed, 16 Nov 2011 21:58:08 -0500 (EST)
Message-Id: <20111116.215808.299077226767455988.davem@davemloft.net>
To: david.decotigny@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, bhutchings@solarflare.com,
        jpirko@redhat.com, joe@perches.com, szymon@janc.net.pl,
        rick.jones2@hp.com, AAbdulla@nvidia.com
Subject: Re: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network
 Kconfig options
From: David Miller <davem@davemloft.net>
In-Reply-To: <e0bb736123d687a921f15e4bb0254eeeabe22dcb.1321496595.git.david.decotigny@google.com>
References: <cover.1321496595.git.david.decotigny@google.com>
	<e0bb736123d687a921f15e4bb0254eeeabe22dcb.1321496595.git.david.decotigny@google.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 16 Nov 2011 18:58:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <david.decotigny@google.com>
Date: Wed, 16 Nov 2011 18:39:05 -0800

> This adds a description of RPS/XPS options and allow them to be
> changed at make menuconfig time.

These aren't meant to be selectable.

They are expressing internal dependencies so we don't have to crap
up the code with the complicated dependency conditional test.

They are meant to be turned on, unconditionally, when the dependencies
are met.  They are not meant to be controllable by the user.

