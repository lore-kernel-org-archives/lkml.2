Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1HIPE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:04:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1HIPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:04:28 -0400
Date: Tue, 9 Aug 2011 17:04:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com
Subject: Re: New vsyscall emulation breaks JITs
Message-ID: <20110809150424.GO5782@one.firstfloor.org>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com> <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org> <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why do we care about pin again?

Binary compatibility is not about someone especially caring.

> 
> $ ./pin -t obj-intel64/opcodemix.so -- /bin/ls
> E:3.0 is not a supported linux release

It works with

echo "2.6.39" > /osrelease
mount --bind /osrelease /proc/sys/kernel/osrelease

-Andi

