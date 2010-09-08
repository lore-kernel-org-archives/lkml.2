Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0IHP14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:27:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45641 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab0IHP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:27:55 -0400
MIME-Version: 1.0
In-Reply-To: <1283957657-17740-1-git-send-email-andi@firstfloor.org>
References: <1283957657-17740-1-git-send-email-andi@firstfloor.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 8 Sep 2010 17:27:37 +0200
Message-ID: <AANLkTimwX_RQfdqbotgdZax-=MLATi7WjsBjkZ+86aaw@mail.gmail.com>
Subject: Re: [PATCH] SYSFS: Allow boot time switching between deprecated and
 modern sysfs layout v2
To: Andi Kleen <andi@firstfloor.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 16:54, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> I have some systems which need legacy sysfs due to old udev versions,
> and it's a big hazzle to compile separate kernels for them.

It's not udev, it's other tools making wrong assumptions like that
directories can not be a symlink to a directory, or that a device is
always the same parent device. It's also not udev which fails on newer
installations, it's the lack of information in the non-extensible
deprecated layout which makes all sorts of tools fail. So please
work-off the text from the old help text instead of blaming the wrong
things here. :)

Kay
