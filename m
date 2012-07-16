Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2GPUo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:44:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60019 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2GPUoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207162041400.28607@skynet.skynet.ie>
References: <alpine.DEB.2.00.1207162041400.28607@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jul 2012 13:44:32 -0700
X-Google-Sender-Auth: mGAn4jvoFfdjwvKCcfxgBAl9FKQ
Message-ID: <CA+55aFypB-Tn+6WQCZauU16QuVGBfr-TjDZrxuxL5SU_bbJTVw@mail.gmail.com>
Subject: Re: [git pull] drm gma500 fixes
To: Dave Airlie <airlied@linux.ie>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 12:42 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> Sorry been travelling and a bit neglectful of some of Alan's
> patches,

I actually took the three Alan sent me already, exactly because they
seemed harmless and I didn't know your schedule.

Your pull has a "gma500: Fix frequency detection" patch that I haven't
seen though, which makes me wonder if Alan wants that one too. He only
sent me a series of the three other patches..

Alan?

            Linus
