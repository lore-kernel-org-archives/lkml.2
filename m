Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0DBUIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:08:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58342 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751791Ab0DBUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:08:37 -0400
Date: Fri, 2 Apr 2010 21:09:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <greg@kroah.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: Re: [PATCH 1/1] tty: release_one_tty() forgets to put pids
Message-ID: <20100402210910.7d44766a@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
	<tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com>
	<20100331151719.8a92b302.akpm@linux-foundation.org>
	<20100402160447.GA19920@redhat.com>
	<20100402160512.GB19920@redhat.com>
	<alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I'll ACK it. But maybe Alan sees some problem/issue I didn't see.

I have no idea. Someone with the time (not me right now) will have to
trace the error paths or perhaps play safe and NULL any pointers so that
they can free it in the destructor only if one was set ?

