Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1GKC7C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 22:59:02 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38404 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab1GKC67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 22:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <1310340634.2405.1.camel@phoenix>
References: <1310340634.2405.1.camel@phoenix>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 10 Jul 2011 22:58:39 -0400
Message-ID: <CAMjpGUeudcbC-df5oteMh4r=8yq=YPw2d0pBX8jA9A+U2_wBCw@mail.gmail.com>
Subject: Re: [PATCH] drivers/video/backlight/adp8860_bl.c: remove a redundant
 assignment for max_brightness
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 19:30, Axel Lin wrote:
> We have set props.max_brightness before registering backlight device.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
