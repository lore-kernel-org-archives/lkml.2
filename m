Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab2JaV4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:56:23 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40497 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596Ab2JaV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <1351702333-8456-1-git-send-email-panto@antoniou-consulting.com>
References: <1351702333-8456-1-git-send-email-panto@antoniou-consulting.com>
Date: Wed, 31 Oct 2012 14:56:20 -0700
X-Google-Sender-Auth: 2r1SY8joBBW3GecHOaOqRNP1jpM
Message-ID: <CA+Bv8XZEpw=811-EMCMFKgZ7z03=U-KxaXBh4oMphdzwO18f8Q@mail.gmail.com>
Subject: Re: [RFC 0/7] Capebus; a bus for SoCs using simple expansion connectors
From: Russ Dill <Russ.Dill@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 9:52 AM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> Capebus is created to address the problem of many SoCs that can provide a
> multitude of hardware interfaces but in order to keep costs down the main
> boards only support a limited number of them. The rest are typically brought
> out to pin connectors on to which other boards, named capes are connected and
> allow those peripherals to be used.
>
> These capes connect to the SoC interfaces but might also contain various other
> parts that may need some kind of driver to work.
>
> Since SoCs have limited pins and pin muxing options, not all capes can work
> together so some kind of resource tracking (at least for the pins in use) is
> required.
>
> Before capebus all of this took place in the board support file, and frankly
> for boards with too many capes it was becoming unmanageable.
>
> Capebus provides a virtual bus, which along with a board specific controller,
> cape drivers can be written using the standard Linux device model.
>
> The core capebus infrastructure is not depended on any specific board.
> However capebus needs a board controller to provide services to the cape devices
> it controls. Services like addressing and resource reservation are provided
> by the board controller.
>
> Capebus at the moment only support TI's Beaglebone platform.
>
> This RFC introduces the core concept; most supporting patches
> have been posted to the relevant places.

There are quite a few TODOs in the code, any chance you could
summarize them in the next header email?
