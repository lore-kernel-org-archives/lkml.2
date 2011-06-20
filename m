Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1FTUxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:53:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1FTUxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:53:23 -0400
Date: Mon, 20 Jun 2011 22:53:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: David Miller <davem@davemloft.net>, "jj@chaosbits.net" <jj@chaosbits.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "segoon@openwall.com" <segoon@openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][Trivial]: ipv4, ping: Remove duplicate icmp.h include
In-Reply-To: <415E440A-6C7F-4ADB-AE81-05AEAD5C3269@gmail.com>
Message-ID: <alpine.LNX.2.00.1106202252380.11049@pobox.suse.cz>
References: <alpine.LNX.2.00.1106201028340.18991@swampdragon.chaosbits.net> <20110620.130515.1956879930278498236.davem@davemloft.net> <415E440A-6C7F-4ADB-AE81-05AEAD5C3269@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Vitaliy Ivanov wrote:

> David,
> 
> It's already in Jiri's trivial tree.

Yeah, it's in my tree as part of larger tree-wide patch.

But that's not a problem really, git can handle that just perfectly well.

-- 
Jiri Kosina
SUSE Labs
