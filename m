Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2JNI7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 04:59:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59496 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2JNI7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 04:59:00 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5079BE5C.8020401@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
Date: Sun, 14 Oct 2012 10:58:59 +0200
X-Google-Sender-Auth: 6XQ0DlGe471azy2Ia_e4CYKzISI
Message-ID: <CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com>
Subject: Re: [Intel-gfx] Intel graphics drm issue?
From: Daniel Vetter <daniel@ffwll.ch>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 9:17 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> One other thing I failed to mention. If i connect the TV HDMI to the Intel
> boards DVI port using the adapter, at power up I get all the BIOS messages
> and can enter the BIOS and all is fine. But when I let it boot all the way
> up like this, I get nothing but "no signal" after leaving BIOS mode. Turning
> the tv on/off, cable plug/unplug does not help.

Can you please boot in that configuration on latest kernel with
drm.debug=0xe added to your kernel cmdline and then attach the
complete dmesg?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
