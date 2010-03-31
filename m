Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0CaWbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:31:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab0CaWbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:31:50 -0400
Message-ID: <4BB3CC80.3030303@zytor.com>
Date: Wed, 31 Mar 2010 15:28:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>	 <4BB2EB1B.8090303@zytor.com>	 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>	 <20100331185916.GA12306@elte.hu> <r2h21d7e9971003311414pc38f5bebk1778a01872657395@mail.gmail.com>
In-Reply-To: <r2h21d7e9971003311414pc38f5bebk1778a01872657395@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 02:14 PM, Dave Airlie wrote:
> Are you testing this btw with initramfs/initrds? I suspect lots of testing
> is being done by people on monolithic kernels, this is just a misc guess,
> considering I couldn't boot from when this landed until rc3 with this option
> on a basic 32-bit install on a dual-core 64-bit CPU, it suggested a
> hole of some sort
> in the test coverage.

Hi Dave,

The only bug report I remember getting from you had no details and was
in reply to another bug report which was, indeed, addressed, so we had
every reason to believe it was being dealt with with the patchset which
did indeed go into -rc3 (and does address a problem with initramfs in
particular cases.)

Clearly James Morris' problem is something unrelated, and regardless of
course of action we need to track it down.

If you also are having problems with -rc3 we would really appreciate as
much detail as possible -- boot logs at the very minimum -- so we have
a chance to at all track down the problems that do exist.

	-hpa
