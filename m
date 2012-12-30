Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab2L3KMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 05:12:46 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:40204 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750946Ab2L3KMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 05:12:43 -0500
Message-ID: <1356862159.7991.6.camel@tellur>
Subject: Re: [git pull] drm fixes
From: Lucas Stach <dev@lynxeye.de>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <alpine.DEB.2.00.1212300420180.7673@skynet.skynet.ie>
References: <alpine.DEB.2.00.1212300420180.7673@skynet.skynet.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Dec 2012 11:09:19 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

Am Sonntag, den 30.12.2012, 04:23 +0000 schrieb Dave Airlie:
> Hi Linus,
> 
[...]
> 
> Lucas Stach (6):
>       drm: tegra: protect DC register access with mutex
        ^^^^ This patch is unnecessary and really shouldn't go in. There
was a brief discussion on the list with the conclusion to disregard this
patch.

Regards,
Lucas

