Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1AYSxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:53:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:53629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab1AYSw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:52:59 -0500
Message-Id: <1bdc18$jcs0b0@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,375,1291622400"; 
   d="scan'208";a="651034976"
Date: Tue, 25 Jan 2011 18:52:55 +0000
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: (not so much) Fun with THP
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, ryomov@gmail.com,
        linux-kernel@vger.kernel.org
References: <0d30dc$krvjbc@orsmga001.jf.intel.com> <20110125175706.GE926@random.random>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110125175706.GE926@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 18:57:06 +0100, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Tue, Jan 25, 2011 at 03:58:30PM +0000, Chris Wilson wrote:
> > On the one F15 box I've dared enable THP with, it hasn't succeeded in
> > booting (with or without KMS).  First it OOMed during lvm:
> 
> Sorry, for x86_32 there was some issue, below is all you need, thanks!

Thank you, I was missing the paravirt patch.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
