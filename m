Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2JNPxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:53:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33706 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2JNPxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:53:35 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <507ADD14.7050503@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com>
	<507A91EA.2030205@cfl.rr.com>
	<CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
	<507AC9DC.4030701@cfl.rr.com>
	<CAKMK7uERj4+QtxMzzHsbxbqvUYNGWxmieZeebS3+CjAbj6Kq1g@mail.gmail.com>
	<507ADD14.7050503@cfl.rr.com>
Date: Sun, 14 Oct 2012 17:53:34 +0200
X-Google-Sender-Auth: yQzJGfm9lbJsKnrKf5L83WGst4o
Message-ID: <CAKMK7uGCyHaXko102_VDus3RCarDobeiRcNKnzjqX3YFK2ouBw@mail.gmail.com>
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

On Sun, Oct 14, 2012 at 5:41 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> There is something amiss. Here is my  i915_pci_probe routine. I Added a
> couple more printks. NONE of these show up in dmesg. Not even the "Entered"
> printk. ????

That's rather strange indeed. Is there another driver bound by
accident to the intel graphics? You can check that with lspci -k
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
