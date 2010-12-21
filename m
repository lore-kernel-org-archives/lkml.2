Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab0LUNL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:11:57 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58128 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0LUNLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:11:54 -0500
X-AuditID: b753bd60-a1f58ba00000044b-0b-4d10a797df8a
Message-ID: <4D10A795.9040809@hitachi.com>
Date: Tue, 21 Dec 2010 22:11:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 0/6] Minor cleanups & fixes for perf-probe(1)
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
In-Reply-To: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/20 23:17), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> Hi,
> 
> This small patchset is just some random cosmetic cleanups I did when
> starting to read perf-probe(1) stuffs.

Hi Franck,

Basically the contains of this series are good to me.
(I've sent my comments)
however, it's less comments on each patch. Please explain
what you did in each patch! (not only on the subject line:-))

Thank you,

> 
> The 3 last patches of this serie are minor fixes though.
> 
> ---
> 
> Franck Bui-Huu (6):
>   perf-tools: make perf-probe -L display the absolute path of the dumped file
>   perf-probe: rewrite show_one_line() to make it simpler
>   perf-probe: clean up redundant tests in show_line_range()
>   perf-probe: Fix line range description since a single file is allowed
>   perf-probe: don't always consider EOF as an error when listing source code
>   perf-probe: handle gracefully some stupid and buggy line syntaxes
> 
>  tools/perf/Documentation/perf-probe.txt |    2 +-
>  tools/perf/util/probe-event.c           |  190 +++++++++++++++++++------------
>  2 files changed, 117 insertions(+), 75 deletions(-)
> 


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
