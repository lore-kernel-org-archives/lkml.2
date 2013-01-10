Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3AJPD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:03:29 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35620 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3AJPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:03:28 -0500
MIME-Version: 1.0
Date: Thu, 10 Jan 2013 09:03:27 -0600
Message-ID: <CAAZUjxB+i4aNqESk93EPp1gZ2e7NNxC_jrDCZPBjs801jAjD0w@mail.gmail.com>
Subject: Intel 3970X and TSC
From: wilson self <wself00@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running kernel.org 3.2, I am having a problem with the clocksource
switching to HPET vs TSC.

The CPU is Intel 3970X 6 core, 3.6GHz and the motherboard is a ASUS
Rampage IV Extreme.

On boot we see this:
TSC synchronization [CPU#0 -> CPU#1]:
Measured 8974546574 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed

Any suggestions on where to look for issues with this CPU?  It works
fine (of course) restricting the cpu to a single core, since it won't
care about synchronization.

Thanks
wilson
