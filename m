Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab2JEKVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:21:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:51800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2JEKVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:21:53 -0400
Message-ID: <1349432466.14388.25.camel@twins>
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 05 Oct 2012 12:21:06 +0200
In-Reply-To: <20121004222755.GC3609@kroah.com>
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>
	 <20121004174626.GB14301@kroah.com> <1349375519.14388.16.camel@twins>
	 <20121004222755.GC3609@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 15:27 -0700, Greg Kroah-Hartman wrote:
> I'm puzzled as well.  Any ideas if I should do anything here or not?

So I think the current v3.5.5 code is fine. I'm just not smart enough to
figure out how 3.6 got fuzzed, this git thing is confusing as hell.
