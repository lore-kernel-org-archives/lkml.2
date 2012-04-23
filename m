Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2DWSp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:45:28 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58908 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab2DWSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:45:27 -0400
Date: Mon, 23 Apr 2012 20:45:09 +0200
From: Anatolij Gustschin <agust@denx.de>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: omap-ush-host: Fix build breakage
Message-ID: <20120423204509.587bf0b2@wker>
In-Reply-To: <CAP05o4JpwtERvLRitBKztrcr_9N+Kxm+SgU=yptUu9VfL3avkg@mail.gmail.com>
References: <1335114510-29413-1-git-send-email-agust@denx.de>
	<CAP05o4JpwtERvLRitBKztrcr_9N+Kxm+SgU=yptUu9VfL3avkg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 11:47:25 +0530
"Munegowda, Keshava" <keshava_mgowda@ti.com> wrote:
...
> Yes, this seems correct!
> But, on which config you are seeing this error?

I was working on some drivers for am3517 based board and I'm seeing
this error since I rebased by patches on v3.4-rc4.

Thanks,
Anatolij
