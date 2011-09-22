Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab1IVIBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:01:44 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45186 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1IVIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:01:42 -0400
MIME-Version: 1.0
Date: Thu, 22 Sep 2011 10:01:42 +0200
Message-ID: <CABJhkKRAO9w85O8f11+V5LoEk08q+S09xDjSXu_bMeb1dSa0Uw@mail.gmail.com>
Subject: Any kernel fails to load after failed pm-hibernate with 3.0.0
From: Magnus Leuthner <magnus.leuthner@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've used pm-hibernate with a custom built 3.0.0 kernel to hibernate
the system. The machine just hung there so I had to power it off
(Thinkpad X61). Now none of my kernels will boot (neither 2.6.x nor
the suspended 3.0.0), after selecing the kernel in the grub menu I get
a black screen with the cursor blinking in the left top and no further
activity (no disk access etc.). I tried the obvious things like adding
in grub the kernel parameters "noresume" or "init=/bin/bash" to no
use, same result. The kernel never shows any signs of life after
selection in grub :(

Any help highly appreciated.

Kind regards
Magnus
