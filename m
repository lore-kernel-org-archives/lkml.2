Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1GLWlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:41:21 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37061 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1GLWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:41:20 -0400
Date: Wed, 13 Jul 2011 00:26:00 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: device support VGA compat Matrox MGA G200ew
Message-ID: <20110712222600.GA6207@electric-eye.fr.zoreil.com>
References: <4E1CB962.1000308@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1CB962.1000308@tlinx.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh <lkml@tlinx.org> :
[...]
> The only other Matrox G200 related option under the DRM support, but it
> says it requires /dev/agpgart to be enabled.  I know the computer doesn't
> have an AGP 'slot' (the card is built-in), but is is possible AGP
> would still be the choice for the interface?

Yes. lspci should list an AGP bridge.

See http://ubuntuforums.org/showthread.php?t=1505532

X seems to know the G200eW. It may help you figuring if
drivers/video/matrox/* (see matroxfb_base.c for the IDs) can be made
to work with this revision or not.

No idea if in-kernel DRM support still works. Imho it will fly like
a brick.

-- 
Ueimor
