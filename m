Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2HUFfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 01:35:02 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50972 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2HUFe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 01:34:59 -0400
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 13:34:57 +0800
Message-ID: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
Subject: udev 182: response timeout for request_firmware in module_probe path
From: Ming Lei <tom.leiming@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

I found that udev 182 doesn't response for the request_firmware in
module_probe path until 30sec later after the 'ADD' event of firmware
device, but no such problem in udev175, sounds like a regression of udev?

I find there was a related discussion in [1], so CC guys who discussed before.

Just grep under kernel root dir, there are about 360 request_firmware callers,
and looks most of them are called in .probe path.


[1], https://lkml.org/lkml/2012/2/19/57

Thanks,
-- 
Ming Lei
