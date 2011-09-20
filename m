Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1ITTpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:45:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58765 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1ITTpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAPoN8K0M2uROGv94Q+bXEkSN47irviPA99jNUBhD6u5qJmm1mA@mail.gmail.com>
References: <CAPoN8K0M2uROGv94Q+bXEkSN47irviPA99jNUBhD6u5qJmm1mA@mail.gmail.com>
Date: Tue, 20 Sep 2011 20:45:04 +0100
Message-ID: <CAPM=9tyEE1Tbr=Wjqr_vJ8jqUjoG97yiXvyFKsV=1AHpfmNeDg@mail.gmail.com>
Subject: Re: DRM troubles with kernel >=2.6.33
From: Dave Airlie <airlied@gmail.com>
To: =?KOI8-R?B?4c7Uz84g7s/XycvP1w==?= <tonn.post@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/20 Антон Новиков <tonn.post@gmail.com>:
> Hi.
> I've got laptop dell inspiron 1521 with ati x1270 (rs690).
> Since kernel version 2.6.33 while I turn KMS on all opengl programms
> hangs with backtrace like this:
> ~/ $ gdb `which glxgears`

Does vblank_mode=0 glxgears work?

Dave.
