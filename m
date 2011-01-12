Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1ALV3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:29:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756406Ab1ALV3s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:29:48 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
 <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
 <20110112114649.5365d518@jbarnes-desktop> <AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 13:28:53 -0800
Message-ID: <AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com>
Subject: Re: [git pull] drm intel only fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 12:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jan 12, 2011 at 11:46 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>
>> Since I doubt we're actually offloading to our video decode kernels for
>> Flash video on your machine
>
> It's the latest 64-bit beta flash player, so maybe it does use hw acceleration.
>
>
>>                       it could very well be a memory bw issue.
>> Can you try this small patch to see if one of the low power watermarks
>> is giving you trouble (note: cut & pasted)?
>
> No difference.

Oh, and I'm also seeing corruption on my sandybridge machine. No video
involved, the gdm login screen is already corrupted this way. Similar
odd shifted lines etc, so I'd assume it's related.

                            Linus
