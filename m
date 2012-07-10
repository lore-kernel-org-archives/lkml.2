Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2GJWQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:16:25 -0400
Received: from fly.hiwaay.net ([216.180.54.1]:49121 "EHLO fly.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab2GJWQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:16:24 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2012 18:16:24 EDT
Date: Tue, 10 Jul 2012 17:08:23 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710220823.GA17364@hiwaay.net>
References: <jknWN-4WG-3@gated-at.bofh.it> <jkulA-O3-3@gated-at.bofh.it> <jkIRz-2Hu-11@gated-at.bofh.it> <jlCTL-A5-5@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710101018.GE15120@arm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Catalin Marinas  <catalin.marinas@arm.com> said:
>Changing the arch/ dir name is easy at this point. My preference is for
>consistency with the official name (that cannot be changed) and the gcc
>triplet.

What ARM Ltd. says is the "official" name isn't necessarily what the
rest of the world will call it.  Linux uses "i386" for what Intel calls
"IA-32" (which virtually nobody else uses).
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
