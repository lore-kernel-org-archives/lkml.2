Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab1EGFE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 01:04:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46066 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1EGFE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 01:04:58 -0400
Message-ID: <4DC4D2F1.7080301@canonical.com>
Date: Fri, 06 May 2011 22:04:49 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: kernel-team@lists.ubuntu.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch not upstream: fix race between open and removal of	framebuffers
References: <BANLkTikAc66kTknEKCX4Mbg7_9CGw+qDfQ@mail.gmail.com>	<4D9DC39A.2080207@canonical.com> <BANLkTikcbGVemWrs+3ZeAvLFafM339CP9w@mail.gmail.com>
In-Reply-To: <BANLkTikcbGVemWrs+3ZeAvLFafM339CP9w@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 09:54 AM, Anca Emanuel wrote:
> On Thu, Apr 7, 2011 at 5:00 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
>> On 04/02/2011 09:37 AM, Anca Emanuel wrote:

<< snip >>

> I can use de PC, but when it wake up from S3, hangs.
> full dmesg at: http://pastebin.com/rhMJrF2x
> uname -a
> Linux ubuntu 2.6.39-rc6 #7 SMP Wed May 4 12:26:39 EEST 2011 x86_64
> x86_64 x86_64 GNU/Linux
> 
> I read that Ubuntu have something like 150 patches NOT upstreamed. Why ?
> And other guys complaining about the hard work they do to maintain
> stable and mainline.
> 
> If you not upstream your work, then what is the ideea ? Keep it only
> for Ubuntu users ?
> 
No, it a diff of about 150 patches for natty from the base 2.6.38 kernel.
We upstream our patches.  Sometimes some patches will slip through for a
while, but they will go up.

Of the 150 or so patches not "upstream" there are only a few that are
ubuntu specific.  Some of the patches are backports from patches upstream
for 2.6.39, some are from linux-next or other development branches,
and some are from projects that aren't upstream for one reason or another
(eg. aufs).

Our delta is public, well documented and available to be examined any
time.  Just pull our kernels from

git://kernel.ubuntu.com/ubuntu/ubuntu-oneiric.git
git://kernel.ubuntu.com/ubuntu/ubuntu-natty.git
..


