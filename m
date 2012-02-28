Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965739Ab2B1VH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:07:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031Ab2B1VHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:07:55 -0500
Date: Tue, 28 Feb 2012 16:06:36 -0500 (EST)
Message-Id: <20120228.160636.1780848090141777111.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: danny.kukawka@bisect.de, dkukawka@suse.de, jeffrey.t.kirsher@intel.com,
        jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] cirrus/mac89x0: print MAC via printk format
 specifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdUudso1YpukfxvGdb2fAYZBJewTgQEh-aU_KB0-U2o6WQ@mail.gmail.com>
References: <CAMuHMdW0Oh7h8tv85ScgHB50vMaZSU7S3cPJRsChnRe2sNL_kA@mail.gmail.com>
	<20120228.154914.662485432055205683.davem@davemloft.net>
	<CAMuHMdUudso1YpukfxvGdb2fAYZBJewTgQEh-aU_KB0-U2o6WQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 13:06:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Feb 2012 22:00:50 +0100

> What about the is_valid_ether_addr() check?

Patches welcome.

