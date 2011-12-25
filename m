Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1LYJnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 04:43:32 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:63185 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1LYJn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 04:43:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAMeQTsZFhWi5WNTrS0=OMibtPJpv-8EQq7ZN=+Ar3F8qN8iqsQ@mail.gmail.com>
References: <CABhjJhOgTKDif9cpgGs2EpYLvM1AJ7+t-rYCLBoRMp7zSykA_g@mail.gmail.com>
	<CAMeQTsZFhWi5WNTrS0=OMibtPJpv-8EQq7ZN=+Ar3F8qN8iqsQ@mail.gmail.com>
Date: Sun, 25 Dec 2011 11:43:28 +0200
Message-ID: <CABhjJhPq5ry1HAmbcCD9Qe=rHDo+8YQJG2jAtmqjo9JTf_sOhw@mail.gmail.com>
Subject: Re: gma500: Attempting to load psb_gfx causes NULL pointer
 dereference error
From: "Dainius (GreatEmerald)" <pastas4@gmail.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could this be a vesa driver clash? Try blacklisting vesafb and make sure
> X is using the fbdev driver. Vesa and psb_gfx doesn't play well together.

Can I do that by passing a kernel option? Since I'm testing the latest
driver on a LiveCD, so it can't store any modprobe settings and such,
and I can't find any information about blacklisting the driver
otherwise.
