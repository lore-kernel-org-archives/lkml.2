Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1BMPvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:51:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab1BMPvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:51:18 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi> <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 13 Feb 2011 07:50:26 -0800
Message-ID: <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com>
Subject: Re: Regression - Xorg start failed
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 11:53 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> Probably should revert first, then work out what is crapping out libpciaccess.

Yeah, I'll revert. The patch is one of those "obviously a good idea,
but in practice it's not something we can change now".

                      Linus
