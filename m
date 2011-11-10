Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1KJV3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:29:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1KJV3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:29:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111110211504.GK8333@google.com>
References: <1318896400-32498-1-git-send-email-msb@chromium.org>
	<alpine.DEB.2.00.1110171727300.13515@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111101246560.21036@chino.kir.corp.google.com>
	<20111110211504.GK8333@google.com>
Date: Thu, 10 Nov 2011 21:29:16 +0000
Message-ID: <CAPM=9twZ=3JKKAwdzj3x00Ktq7NZKyhKdQDpqtZApRyxf_g9EQ@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid switching to text console if there is no panic timeout
From: Dave Airlie <airlied@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 9:15 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> David Rientjes (rientjes@google.com) wrote:
>> On Mon, 17 Oct 2011, David Rientjes wrote:
>>
>> > On Mon, 17 Oct 2011, Mandeep Singh Baines wrote:
>> >
>> > > From: Hugh Dickins <hughd@chromium.org>
>> > >
>> > > Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
>> > > we're going to reboot immediately, the user will not be able to see the
>> > > messages anyway, and messing with the video mode may display artifacts,
>> > > and certainly get into several layers of complexity (including mutexes and
>> > > memory allocations) which we shall be much safer to avoid.
>> > >
>> > > Signed-off-by: Hugh Dickins <hughd@google.com>
>> > > [ Edited commit message and modified to short-circuit panic_timeout < 0
>> > >   instead of testing panic_timeout >= 0.  -Mandeep ]
>> > > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
>> > > Cc: Dave Airlie <airlied@redhat.com>
>> > > Cc: Andrew Morton <akpm@linux-foundation.org>
>> > > Cc: dri-devel@lists.freedesktop.org
>> >
>> > Acked-by: David Rientjes <rientjes@google.com>
>> >
>>
>> Dave, where do we stand on this?  I haven't seen it hit Linus' tree and I
>> don't see it in git://people.freedesktop.org/~airlied/linux.

I've just pulled it into my local drm-next, thanks for reminding me.

Dave.
