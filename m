Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1KQDFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:05:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41691 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab1KQDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:05:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111116.215808.299077226767455988.davem@davemloft.net>
References: <cover.1321496595.git.david.decotigny@google.com>
 <e0bb736123d687a921f15e4bb0254eeeabe22dcb.1321496595.git.david.decotigny@google.com>
 <20111116.215808.299077226767455988.davem@davemloft.net>
From: David Decotigny <david.decotigny@google.com>
Date: Wed, 16 Nov 2011 19:04:58 -0800
Message-ID: <CAG88wWYgUkStZk988iWzbWf_=1Ze-Rtvs82sMrZoeuFPQphaUA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network Kconfig options
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, bhutchings@solarflare.com,
        jpirko@redhat.com, joe@perches.com, szymon@janc.net.pl,
        rick.jones2@hp.com, AAbdulla@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 6:58 PM, David Miller <davem@davemloft.net> wrote:
> From: David Decotigny <david.decotigny@google.com>
> Date: Wed, 16 Nov 2011 18:39:05 -0800
>
>> This adds a description of RPS/XPS options and allow them to be
>> changed at make menuconfig time.
>
> These aren't meant to be selectable.

Ok. I only needed this for our compilation scripts in order to make
sure I didn't have my CONFIG_* wrong in patch 4/9. I don't need this
patch anymore.

David, should I re-send an updated v7 version of this series with this
patch removed? Or is it Ok if I simply mark this patch as rejected in
patchwork and stick to patch series v6?
