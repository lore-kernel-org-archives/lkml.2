Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0KIBux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:50:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45333 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0KIBuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:50:52 -0500
Date: Tue, 9 Nov 2010 02:50:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings v2
Message-ID: <20101109015051.GC21551@basil.fritz.box>
References: <1289251229-19589-1-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.00.1011082238420.2900@localhost6.localdomain6>
 <87oc9zqy0l.fsf@basil.nowhere.org>
 <20101108221528.GH6273@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108221528.GH6273@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, Andi I proposed to define variable as u64 and convert it back to u32 at procedure
> exit point. That would be clean, and I still think so ;) Though I'm fine with
> either way (I just thought about ones who will be reading this code in future,
> and since most the rdmsrl callers already use u64 and unsigned long, this would
> be consistent as well).

I didn't use u64 because that would use more code on i386

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
