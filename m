Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2BGFY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:24:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:47068 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2BGFY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:24:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104010881"
Subject: Re: [patch]block: fix ioc locking warning
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
In-Reply-To: <20120207005900.GF21292@google.com>
References: <20120206151219.GC30752@redhat.com> <4F2FFB21.9000202@kernel.dk>
	 <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com>
	 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
	 <20120206172706.GB21292@google.com> <20120206203604.GC21292@google.com>
	 <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
	 <20120207003948.GE21292@google.com>
	 <1328575430.21268.69.camel@sli10-conroe>
	 <20120207005900.GF21292@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 13:22:58 +0800
Message-ID: <1328592178.21268.78.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 16:59 -0800, Tejun Heo wrote:
> * Test with the this_q != locked_q trylock patch.
this one slightly reduces the regression. without it, the regression is
about 17%, with it, the regression is about 12%. Test result is stable.

