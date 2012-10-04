Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab2JDQza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:55:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53251 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab2JDQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:55:28 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <506D4BCD.3020402@codeaurora.org>
References: <506D4BCD.3020402@codeaurora.org>
Date: Thu, 4 Oct 2012 09:55:27 -0700
Message-ID: <CAOesGMjotnx_6HiwngRO9OaZYGGAexiwZ_shkOK7qROZcjDmqA@mail.gmail.com>
Subject: Re: arm-soc maintainer entry
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 4, 2012 at 1:41 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Is the arm@kernel.org alias going to be added into the MAINTAINERS file?
> Should anybody be sending mails to this address?
>
> It seems I asked this over a year ago and the response was positive but
> nothing ever happened[1]. Maybe something like below? I only ask because
> get_maintainer.pl isn't picking up this email.

I've been holding off re-proposing this, mostly because life is easier
for us if we don't get arm@kernel.org cc:d on every single patch by
people who run get_maintainers.pl -- it's the equivalent of getting
linux-arm-kernel cc:d to your inbox. It's better signal-to-noise ratio
if it's mostly platform maintainers that email us on that address with
pull requests or patches they want applied.

But yeah, it also means that the maintainer structure is undocumented.
I'm open for suggestions.


-Olof
