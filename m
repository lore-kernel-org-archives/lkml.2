Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0I1LJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:09:12 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:54725 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0I1LJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:09:10 -0400
Subject: Re: [linux-pm] [TuxOnIce-devel] [PATCH] Hibernate: Implement
 readahead when resuming
From: Bojan Smojver <bojan@rexursive.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: tuxonice-devel@tuxonice.net, linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201009281156.51365.Martin@lichtvoll.de>
References: <1285416056-9735-1-git-send-email-nigel@tuxonice.net>
	 <4C9E79BD.4030003@tuxonice.net> <201009281006.49727.Martin@lichtvoll.de>
	 (sfid-20100928_101216_879880_B5940F00)  <201009281156.51365.Martin@lichtvoll.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 21:09:08 +1000
Message-ID: <1285672148.2606.11.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 11:56 +0200, Martin Steigerwald wrote:
> So in-kernel-suspend actually seems to write faster, but TuxOnIce had
> lzo compressor active. 

If you used recent versions of Rafael's tree, this will have LZO as
well. Just look at kernel/power/swap.c. If it has lzo.h there, it's
being used (unless you told it not to).

-- 
Bojan

