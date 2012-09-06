Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2IFCr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 22:47:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33257 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2IFCrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 22:47:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120905173011.7a1111f0@pyramind.ukuu.org.uk>
References: <s5hd3222azc.wl%tiwai@suse.de> <CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
 <s5hd32122hw.wl%tiwai@suse.de> <CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
 <s5hpq61j9qx.wl%tiwai@suse.de> <CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
 <20120905140304.5c5c58a4@pyramind.ukuu.org.uk> <CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
 <20120905173011.7a1111f0@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Sep 2012 19:47:03 -0700
X-Google-Sender-Auth: 3rVthRw_BQZqR68u_ZkzQpVlZ9U
Message-ID: <CA+55aFwMLp31bZhyHXxsqr=bbi9Kb+x3hrE8MF9eKydTbUTRLg@mail.gmail.com>
Subject: Re: A workaround for request_firmware() stuck in module_init
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 9:30 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> It's not about a workaround but about doing it properly for the long term
> and doing it in one place. It's also not a "great change", its a small
> change.

udev needs to get fixed regardless.

Stop this "we can break stuff" crap. Who maintains udev? Regressions
are not acceptable. I'm not going to change the kernel because udev
broke, f*ck it.

Seriously. More projects need to realize that regressions are totally
and utterly unacceptable.

The "long term cleaner issues" can be handled separately, but are
*not* an excuse to work around clear regressions in core packages.
That just encourages those package maintainers to be shit maintainers.

Just fix udev, which had a regression. And stop blaming the kernel for
user space breakage! Tying these kinds of things together ("udev
broke, so now we need to change the kernel") is *wrong*. It's totally
unacceptable to tie the two together that way.

          Linus
