Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab0L3Mup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 07:50:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0L3Muo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 07:50:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Robin Holt <holt@sgi.com>
Subject: Re: [patch 1/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
Date: Thu, 30 Dec 2010 13:50:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com> <20101230124535.GA3306@sgi.com>
In-Reply-To: <20101230124535.GA3306@sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301350.28862.arnd@arndb.de>
X-Provags-ID: V02:K0:s5EbNxXiLVFinQZCGA0YBYT0+IHL3h7rRoqmNDdGUH9
 NEwTIyER79ffGtsxHOCbOTkjFJHbjj3HTPDG4V7x6pzn63TPuc
 V8/7sWYa4WE5j0CdCdueJRObcgDRh/sJyuaMj9CJ7erYYS5Va6
 KceaMJerSBeAXoLI3q3kcQoyjtQZctqxdGjIlk1k37YsNJYxO1
 sQk9eaOdP+WNj44Pbc3QQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 December 2010, Robin Holt wrote:
> Doesn't this patch series break the 'bisectable' rule for patches?
> I think you can get by with adding a CONFIG_EXPERT selects CONFIG_EMBEDDED
> in the first patch and the last patch removing that same selects.

How about leaving it that way during the merge window even? That would
help people sending git pull requests that add new dependencies on
CONFIG_EMBEDDED. David can submit another patch that removes the
temporary CONFIG_EMBEDDED option along with any new users in -rc2
or for 2.6.39 then.

	Arnd
