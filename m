Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0KBDKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:10:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:37533 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0KBDKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:10:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,278,1286175600"; 
   d="scan'208";a="853190726"
Subject: Re: 2.6.36 io bring the system to its knees
From: Shaohua Li <shaohua.li@intel.com>
To: Aidar Kultayev <the.aidar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Pekka Enberg <penberg@kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTim-hgA3-9T_N5k53Sga5LMazMQPmmQZzQsoQvRY@mail.gmail.com>
References: <AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
	 <AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
	 <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
	 <20101028090002.GA12446@elte.hu>
	 <AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
	 <20101028133036.GA30565@elte.hu>	<20101028170132.GY27796@think>
	 <AANLkTikgO=n88ZAQ6EYAg1+aC1d0+o923FYyhkOouaH5@mail.gmail.com>
	 <20101029145212.GA21205@thunk.org>
	 <AANLkTim-A7DLOOw4myQU3Lfip+ZEE32F2Ap_PJXuxG6G@mail.gmail.com>
	 <20101030091440.GA15276@elte.hu>
	 <AANLkTim-hgA3-9T_N5k53Sga5LMazMQPmmQZzQsoQvRY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 11:10:19 +0800
Message-ID: <1288667419.8722.965.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 21:02 +0800, Aidar Kultayev wrote:
> Hi,
> 
> here is what I have :
> 
> .ext4 mounted with data=ordered
> .-tip tree ( uname -a gives : Linux pussy 2.6.36-tip+ )
> 
> here is the latencytop & powertop & top screenshot:
> 
> http://picasaweb.google.com/lh/photo/bMTgbVDoojwUeXtVdyvIKw?feat=directlink
> 
> the system is/was doing :
> .dd if=/dev/zero of=test.10g bs=1M count=10000;rm test.10g
> .netbeans
> .compiling gcc-4.5.1
> .running VBox, which wasn't doing any IO. The guest os was idle in other words
> .vlc
> .chromium
> .firefox
> and bunch of other small stuff.
> 
> Even without having running DD, the mouse cursor would occasionally
> lag. The alt+tab effect in KWin would take 5+seconds to workout.
> When I run DD on top of the workload it consistently made system much
> more laggy. The cursor would freeze much more frequent. It is like if
> you drag your mouse physically, but the cursor on the screen would
> jump discretely, in other words there is no continuity.
> Music would stop.
> 
> I am free to try out anything here.
would you please try the vm_exec protect patch here?
http://www.spinics.net/lists/linux-mm/msg09617.html

Thanks,
Shaohua

