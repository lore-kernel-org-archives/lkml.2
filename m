Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0JAPDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:03:54 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:17553
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756736Ab0JAPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:03:53 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1dbaL1432N98dNzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L9M9T3-01-F4C-02
X-M-MSG: 
Date: Fri, 1 Oct 2010 17:03:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "oleg@redhat.com" <oleg@redhat.com>
Subject: Re: [PATCHv2 0/2] oprofile, x86: allow backtrace for 32bit apps
 under 64bit kernel
Message-ID: <20101001150303.GD13563@erda.amd.com>
References: <1285771607-12089-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285771607-12089-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 10:46:45, Jiri Olsa wrote:
> I'm sending reworked version of the support for backtrace of ia32
> applications under 64bit kernels.
> 
> updates are based on comments by Robert Richter
> 
> v2:
> 	- using struct stack_frame for 64bit processes
> 	- using struct stack_frame_ia32 for compat processes
> 	- added inline function x86_backtrace_32 which is
> 	  just empty stub for !CONFIG_COMPAT
> 	- I did not figure out a smart way to share dump code between
> 	  32 and 64 bits. I'm currently under impression the code is
> 	  so far easy and light enough to live separately and mixing
> 	  the code would come with more complexity.
> 
> 
> attached patches:
> - 1/2 using struct stack_frame for 64bit processes dump
> - 2/2 adding backtrace dump for 32bit process in compat mode
> 
> please let me know what you think
> 
> thanks,
> jirka
> ---
>  arch/x86/oprofile/backtrace.c |   70 ++++++++++++++++++++++++++++++++++------
>  1 files changed, 59 insertions(+), 11 deletions(-)

Applied to oprofile/core. Thanks Jirka.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

