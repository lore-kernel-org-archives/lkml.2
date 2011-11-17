Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1KQRjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:39:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37352 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1KQRjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:39:43 -0500
MIME-Version: 1.0
In-Reply-To: <1321511678.3274.30.camel@edumazet-laptop>
References: <cover.1321481064.git.david.decotigny@google.com>
 <185a0f33c69ff07e8fe3482828b368371420bf47.1321481064.git.david.decotigny@google.com>
 <1321511678.3274.30.camel@edumazet-laptop>
From: David Decotigny <david.decotigny@google.com>
Date: Thu, 17 Nov 2011 09:39:21 -0800
Message-ID: <CAG88wWbiwVKUVtQxV=FzBTfaCngeGYXL9M_00NQKCgbEqic4-w@mail.gmail.com>
Subject: Re: [PATCH net-next v6 7/9] forcedeth: implement ndo_get_stats64() API
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:34 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> You should use the _bh variants.

Oooops. It's unforgivable: the sky2 implementation you mentioned in a
previous message was the simple and right model to follow. Grrrrrr.
Sending a fix shortly.

Thanks!
