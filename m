Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1HKVFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:05:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36967 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1HKVFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:05:30 -0400
Date: Thu, 11 Aug 2011 23:05:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alex Neronskiy <zakmagnus@chromium.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
Message-ID: <20110811210525.GR5782@one.firstfloor.org>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org> <1312999364-21104-2-git-send-email-zakmagnus@chromium.org> <m2bovvn5s5.fsf@firstfloor.org> <20110811190402.GC17530@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811190402.GC17530@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No because the serial console driver does a touch_nmi_watchdog().  So if
> we are trying to output debug info _before_ the lockup detector goes off,
> we effectively shoot ourselves in the foot by reseting the lockup detector
> everytime we print something.  Hence we are trying to capture the data and
> output using another interface.

Well surely that's fixable in the serial driver? Maybe set some global
on that CPU to disable it.

-Andi
