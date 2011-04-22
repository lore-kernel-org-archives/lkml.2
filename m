Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1DVIwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:52:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1DVIwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:52:00 -0400
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
In-Reply-To: <BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
	 <1303398203-2918-5-git-send-email-dzickus@redhat.com>
	 <20110422081838.GA24011@elte.hu>
	 <BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 10:54:36 +0200
Message-ID: <1303462476.2035.215.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 12:43 +0400, Cyrill Gorcunov wrote:
> we need a different event and counters for watchdog.
> 
Does it count the same thing though? If so we could look at having
alternative encodings support (we might need something like that for
offcore too).

