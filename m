Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1AFX74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:59:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab1AFX7y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:59:54 -0500
MIME-Version: 1.0
In-Reply-To: <4d2654c410489a1b90@agluck-desktop.sc.intel.com>
References: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com> <4d2654c410489a1b90@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 15:53:01 -0800
Message-ID: <AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 3:48 PM, Luck, Tony <tony.luck@intel.com> wrote:
> Untested on X86.  Builds and boots on ia64 (both normally and with
> maxcpus=8 to limit the number of cpus).
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Looks much better to me, and gets rid of that silly #ifdef that I reacted to.

But no hurry, this looks low-priority. So let's make this go through
the x86 tree and get merged later, after it has passed whatever normal
tests that the -tip tree goes through. Ok?

                        Linus
