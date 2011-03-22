Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1CVU6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:58:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1CVU6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <1300782452-528-1-git-send-email-hs@denx.de>
References: <1291451028-22532-1-git-send-email-hs@denx.de> <1300782452-528-1-git-send-email-hs@denx.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Mar 2011 14:58:09 -0600
X-Google-Sender-Auth: J6m0IQZNcaYo_rNyUgIwzb3sDq4
Message-ID: <AANLkTi=Da06s2WeA0+9fshBV2ME-ADHPBWxZ5iL6rM_T@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] powerpc, 52xx: add charon board support
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Wolfram Sang <w.sang@pengutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 2:27 AM, Heiko Schocher <hs@denx.de> wrote:
> cc: Wolfram Sang <w.sang@pengutronix.de>
> cc: Grant Likely <grant.likely@secretlab.ca>
> cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> cc: linux-fbdev@vger.kernel.org
> cc: devicetree-discuss@ozlabs.org
> cc: Ben Dooks <ben@simtec.co.uk>
> cc: Vincent Sanders <vince@simtec.co.uk>
> cc: Samuel Ortiz <sameo@linux.intel.com>
> cc: linux-kernel@vger.kernel.org
> cc: Randy Dunlap <rdunlap@xenotime.net>
> cc: Wolfgang Denk <wd@denx.de>
> cc: Paul Mundt <lethal@linux-sh.org>
>
> changes since v5:
> - repost complete patchseries, as Paul Mundt suggested
> - rebased against current head
> - add Acked-by from Samuel Ortiz (MFD parts)
>  http://www.spinics.net/lists/linux-fbdev/msg02550.html
>  http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-01/msg11798.html
>
>  and Benjamin Herrenschmidt (DTS parts)
>  http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-February/088279.html
> - removed patch
>  "powerpc, mpc5200: update mpc5200_defconfig to fit for charon board."
>  therefore added
>  "powerpc, tqm5200: update tqm5200_defconfig to fit for charon board."

Why?  As Wolfram mentioned, I'd rather see mpc5200 defconfig used.
Eventually I'd like to remove tqm5200_defconfig

I'll look through the rest of the patches soon.

g.
