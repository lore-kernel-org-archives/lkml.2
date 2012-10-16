Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab2JPQqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:46:19 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39624 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2JPQqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <20121016152023.GA25506@redhat.com>
References: <20121016152023.GA25506@redhat.com>
From: Michael Spang <spang@google.com>
Date: Tue, 16 Oct 2012 12:45:56 -0400
Message-ID: <CAC5F_1=tiGUtWOsOQ17vEYqVxuoVuoEH_nmEZ3BoL0dsgXJn3w@mail.gmail.com>
Subject: Re: USB keyboard backlight powering down.
To: Dave Jones <davej@redhat.com>, Michael Spang <spang@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, greno@verizon.net,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 11:20 AM, Dave Jones <davej@redhat.com> wrote:
> Gerry (CC'd) reported a bug to us that since 3.6.1, his illuminated
> Logitech USB keyboard doesn't light up until he hits a key, and then
> it immediately powers back off, defeating the purpose of having an
> illumated keyboard.
>
> Looking over the 3.6.1 changelog, I see this change, which sounds
> like it might be responsible ?
>
> commit ee537508bdc0c00b96ac497f3d82a68f820e6182
> Author: Michael Spang <spang@chromium.org>
> Date:   Fri Sep 14 13:05:49 2012 -0400
>
>     Increase XHCI suspend timeout to 16ms

I don't think this is related to your problem, as this patch is in
suspend/resume code. It just allows the controller more time to halt.

Thanks,
Michael
