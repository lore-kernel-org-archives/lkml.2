Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab1H3HDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:03:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:30350 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab1H3HC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,300,1312182000"; 
   d="scan'208";a="46394659"
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
Date: Tue, 30 Aug 2011 00:02:57 -0700
In-Reply-To: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	(Daniel Ehrenberg's message of "Mon, 29 Aug 2011 10:33:24 -0700")
Message-ID: <m2y5ybnzz2.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Ehrenberg <dehrenberg@google.com> writes:
>
> Has anything like this been discussed or implemented?

There was a lot of discussion and some patches on "retry based AIO"
a few years ago. Didn't really go anywhere, but there are still
assorted leftovers in the code.

Then there was the "syslets" approach, but that is also still born.

Probably needs to be revisited from scratch. The network
layer is also badly in need of a better aio interface that supports
zero copy.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
