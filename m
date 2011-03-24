Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab1CXAyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:54:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933467Ab1CXAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110323083329.64a738c6@jbarnes-desktop>
References: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie>
 <AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
 <AANLkTi=zcXFOGj+pi1YSVY1kHoULEAQRNrnzmw2Pexns@mail.gmail.com> <20110323083329.64a738c6@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Mar 2011 17:54:00 -0700
Message-ID: <AANLkTikoXWGsbFnXgzv_FZDW9SEPo6HnoGg_ndo0_hn5@mail.gmail.com>
Subject: Re: [git pull] drm next tree
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 8:33 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Chris mentioned a7a75c8f7 on irc, not sure if it was regarding this
> issue though, but it does seem a likely candidate.

Yup, that revert fixes it for me.

                Linus
