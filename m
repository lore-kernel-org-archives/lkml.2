Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1KIINJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:13:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1KIINH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ9D=p6oqXjpATFLNYhjb11O2wSErxC220kZ5Ngfq869H3BJmw@mail.gmail.com>
References: <CAJ9D=p6oqXjpATFLNYhjb11O2wSErxC220kZ5Ngfq869H3BJmw@mail.gmail.com>
Date: Wed, 9 Nov 2011 09:13:06 +0100
Message-ID: <CACna6rw2f1wPtLBO6syEtK6TKiF6oTFZtwoiu0c3rYAXjs-H+g@mail.gmail.com>
Subject: Re: r600 hdmi sound issue
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg Dietsche <greg@gregd.org>
Cc: maraeo@gmail.com, airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/9 Greg Dietsche <greg@gregd.org>:
> Hi,
> I have a ASUS M4A89GTD motherboard and when I play back music in Rhythmbox,
> there is no sound (hdmi connection). Also, the playback speed is in a sort
> of fast forward (for example, after a few seconds of real time, rhythmbox
> shows something like 30 seconds into the song). This seems to be a kernel
> regression. I know that it started with 3.0, is present in 3.1, and is not
> working in 3.2-rc1, so it is still a problem.
>
> I bisected and found my self here: fe6f0bd03d697835e76dd18d232ba476c65b8282.
> However due to some graphical issues, I'm not actually able to test that
> commit. I tried reverting that commit, but the problem wasn't fixed.
>
> I'd like to see this problem fixed and can compile and test patches as
> necessary. Please let me know if you need more information - I'm happy to
> provide it :)

fe6f0bd03d697835e76dd18d232ba476c65b8282 is not likely. I suspect you
just experience results of so-called-fix:

805c22168da76a65c978017d0fe0d59cd048e995

drm/radeon/kms: disable hdmi audio by default

I'm trying to get in contact with ppl affected by issues when enabling
audio. Hopefully we can fix audio support and enable it by default
again.

For now, please load radeon module with "audio=1", or simply boot with
radeon.audio=1

-- 
Rafał
