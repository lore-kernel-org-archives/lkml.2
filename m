Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1KQRrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:47:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53344 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1KQRrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:47:15 -0500
Message-ID: <1321552029.2751.88.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH net-next v6 7/9] forcedeth: implement ndo_get_stats64()
 API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Decotigny <david.decotigny@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Date: Thu, 17 Nov 2011 18:47:09 +0100
In-Reply-To: <CAG88wWbiwVKUVtQxV=FzBTfaCngeGYXL9M_00NQKCgbEqic4-w@mail.gmail.com>
References: <cover.1321481064.git.david.decotigny@google.com>
	 <185a0f33c69ff07e8fe3482828b368371420bf47.1321481064.git.david.decotigny@google.com>
	 <1321511678.3274.30.camel@edumazet-laptop>
	 <CAG88wWbiwVKUVtQxV=FzBTfaCngeGYXL9M_00NQKCgbEqic4-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 novembre 2011 à 09:39 -0800, David Decotigny a écrit :
> On Wed, Nov 16, 2011 at 10:34 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > You should use the _bh variants.
> 
> Oooops. It's unforgivable: the sky2 implementation you mentioned in a
> previous message was the simple and right model to follow. Grrrrrr.
> Sending a fix shortly.
> 

Dont worry, we all did the exact same mistakes :)


