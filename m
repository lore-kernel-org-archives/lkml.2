Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1AJSxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:53:03 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:15484 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab1AJSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:53:01 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANPkKk2rR7Ht/2dsb2JhbACkR3OjF5gvhUwEhGeGIw
From: Roland Dreier <rdreier@cisco.com>
To: "J.H." <warthog9@kernel.org>
Cc: David Brown <davidb@codeaurora.org>, sedat.dilek@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ftpadmin@kernel.org, webmaster@kernel.org
Subject: Re: patchwork.kernel.org down
References: <AANLkTik4ktaeyDG3ihh-YRB+WVLxA46wSLOgWy6iY_68@mail.gmail.com>
	<20101220204936.GA21290@huya.qualcomm.com>
	<4D0FFC4B.9050301@kernel.org> <ada62u3dkv2.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 10 Jan 2011 10:52:50 -0800
In-Reply-To: <ada62u3dkv2.fsf@cisco.com> (Roland Dreier's message of "Wed, 05
	Jan 2011 14:52:17 -0800")
Message-ID: <adaei8k8ubh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  > More excitement from https://bugzilla.kernel.org/show_bug.cgi?id=20702
 >  > 
 >  > Anyone want to take a stab at it?  I know I'd be appreciative.  I am
 >  > running a debug kernel with everything I could find and enable I even
 >  > remotely thought might prove helpful.  Nothing has jumped out yet though.
 > 
 > A little late, but perhaps running with the patch below might help us
 > make a bit of progress.  The idea is to dump the last /proc/net file
 > opened and closed, so we can at least have a clue as to where the crash
 > is coming from.  This should add lines like 
 > 
 >     last procfs open:  /proc/2443/net/arp
 >     last procfs close: /proc/2443/net/arp
 > 
 > to the oops output, so maybe we can zero in on things after you get a
 > crash with this applied.

Just curious -- did you get a chance to run with this patch applied?
Did you collect any oopses yet?

 - R.
