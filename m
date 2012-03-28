Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2C1Mzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:55:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41204 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2C1Mzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203271406550.12921@skynet.skynet.ie>
References: <alpine.DEB.2.00.1203271406550.12921@skynet.skynet.ie>
Date: Wed, 28 Mar 2012 13:55:32 +0100
Message-ID: <CAPM=9tyM5G1i0x4-Os-3wk3Htg4spe-HmTawPM=x_Fv-OjqYYQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> gma500 build fix + some regression fixes for nouveau/radeon, along with
> one radeon patch that was posted a while ago and I missed and it also required
> rebasing around some other stuff.

I've added one more commit to this.

commit d936622c36273a9ecfbb4aacf26cd29405995159
Author: Michel Dänzer <michel.daenzer@amd.com>
Date:   Wed Mar 28 08:52:32 2012 +0200

    drm/radeon: Only warn if the intra-domain offset actually exceeds the limit.

it had 3 reports/tests.

Dave.
