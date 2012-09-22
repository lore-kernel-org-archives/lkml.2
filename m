Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2IVHpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 03:45:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41330 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2IVHpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 03:45:49 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAOesGMjWcEXubD9ei+r=Xxz9KdJcFMsuk0pEN08nNsas8we3_A@mail.gmail.com>
References: <CAOesGMjWcEXubD9ei+r=Xxz9KdJcFMsuk0pEN08nNsas8we3_A@mail.gmail.com>
Date: Sat, 22 Sep 2012 00:45:47 -0700
Message-ID: <CAOesGMivmSRpj1q29jBL6DM3YCa75tzguuTu_xZ9MzDvHvkHGw@mail.gmail.com>
Subject: Re: Status of arm-soc for 3.7
From: Olof Johansson <olof@lixom.net>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick update:

On Thu, Sep 20, 2012 at 11:21 PM, Olof Johansson <olof@lixom.net> wrote:

> What's left to deal with is:
>
> * smp_ops branch, since multiplatform depends on it to allow building
> more than one platform.

smp_ops and platform_data have both been merged into
next/multiplatform now, and I have been successful at building a
kernel that includes all current multiplatform-enabled platforms.


-Olof
