Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab0JIAq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:46:58 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:32874 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070Ab0JIAq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:46:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19631.47960.804661.384152@quad.stoffel.home>
Date: Fri, 8 Oct 2010 20:46:16 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        John Stoffel <john@stoffel.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.36-rc7
In-Reply-To: <201010082303.17706.agruen@suse.de>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	<19631.15310.568446.991954@quad.stoffel.home>
	<201010081717.25940.tvrtko.ursulin@sophos.com>
	<201010082303.17706.agruen@suse.de>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Gruenbacher <agruen@suse.de> writes:

Andreas> On Friday 08 October 2010 18:17:25 Tvrtko Ursulin wrote:
>> Doesn't really solve ordering inside groups so maybe we do not need
>> priorities at all just these three classes?

Andreas> Applications can easily make the priority they register with
Andreas> configurable (and default to something in their "range" if we
Andreas> define such ranges).  Wouldn't this be enough?

What about conflicts, when two applications register with the same
priority?  And then one of the them exits, dies, fails, and
re-registers itself.

Does it get the same slot back?  Does it goto the end of the line?  If
it's an HSM handling (or other content manipulation tool) what
happens?  

These are the questions which need to be answered, and the ABI updated
to reflect these questions.  Even if it's just "We don't care..." it
needs to be spelled out.

John
