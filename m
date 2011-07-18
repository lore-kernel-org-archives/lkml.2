Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1GRM1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:27:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36247 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1GRM1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E2423C4.6090906@msgid.tls.msk.ru>
References: <1310979967-13470-1-git-send-email-levinsasha928@gmail.com>
	<CAOJsxLG9h_L8x6-W67bMT1ObQKc=ZoLUKO8ocY4QQs=0rhw5ZQ@mail.gmail.com>
	<4E2423C4.6090906@msgid.tls.msk.ru>
Date: Mon, 18 Jul 2011 15:27:49 +0300
X-Google-Sender-Auth: 8_-ct-R7OEeymEdGxc3ZX4X7NQw
Message-ID: <CAOJsxLFEBknf8m5k6XOG=by_-avWT5P+ScoBBHfO0sgZbo_kSA@mail.gmail.com>
Subject: Re: [PATCH] init: Support mounting devices from kernel command line
From: Pekka Enberg <penberg@kernel.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 3:15 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>> In /tools/kvm we are interested in such feature to allow us to automatically
>>> mount user home directory using virtio-9p from the host to the guest
>>> filesystem under '/hostfs'.
>
> Can't the same be done within initramfs just as easy?
>
> Long time ago when initramfs first appeared the plan was to,
> more or less, move all that mounting and root= handling
> functionality to userspae, and here we're adding more
> to kernel.  To me that sounds backwards...

Well, we can currently boot distro images using custom kernel combined
with distro initramfs. I'm not sure how we can inject our mount point
to initramfs as easily.

I don't think it's backwards progress but then again, I don't really
use initramfs or modules for that matter so maybe I'm just old
fashioned.

                        Pekka
