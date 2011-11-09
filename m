Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1KIBRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:17:31 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41900 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1KIBRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ9D=p6oqXjpATFLNYhjb11O2wSErxC220kZ5Ngfq869H3BJmw@mail.gmail.com>
References: <CAJ9D=p6oqXjpATFLNYhjb11O2wSErxC220kZ5Ngfq869H3BJmw@mail.gmail.com>
Date: Tue, 8 Nov 2011 19:17:29 -0600
X-Google-Sender-Auth: 2wvyK2AMeWeTG0LJMyaOd-3W7Ww
Message-ID: <CAJ9D=p4gWqO3zChGFz-Uv0qpn2KDdg0d=CTk5LBShKoMA53ZEw@mail.gmail.com>
Subject: Re: r600 hdmi sound issue
From: Greg Dietsche <greg@gregd.org>
To: maraeo@gmail.com, airlied@redhat.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 7:08 PM, Greg Dietsche <greg@gregd.org> wrote:
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
>
> Thanks!
> Greg
>
>

...resending in plain text to properly include the lkml...

Greg
