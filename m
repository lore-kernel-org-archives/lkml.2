Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0IOCmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 22:42:35 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44913 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0IOCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 22:42:34 -0400
X-AuditID: b753bd60-a9336ba000000226-55-4c903298a790
Message-ID: <4C903295.9030505@hitachi.com>
Date: Wed, 15 Sep 2010 11:42:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH RESEND 0/5] kprobes cleanups
References: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Could you pull it to -tip tree?
I've checked this series can be applied to the latest tip/master. :)

Thank you,

(2010/09/15 10:04), Namhyung Kim wrote:
> Hello,
> 
> This is a resend of my previous works on kprobes. All patches in this
> series are small cleanups and got acked by Masami. Please consider
> applying it.
> 
> Thanks.
> 
> ---
> 
> Namhyung Kim (5):
>   kprobes: remove redundant address check
>   kprobes: verify jprobe entry point
>   kprobes: make functions static
>   kprobes: remove __dummy_buf
>   kprobes: add sparse context annotations
> 
>  arch/x86/kernel/kprobes.c |   11 +++--------
>  kernel/kprobes.c          |   22 ++++++++++++++--------
>  2 files changed, 17 insertions(+), 16 deletions(-)
> 
> --
> 1.7.2.2
> 

