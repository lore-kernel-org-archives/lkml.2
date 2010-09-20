Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0ITXzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:55:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53736 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0ITXzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:55:09 -0400
X-AuditID: b753bd60-a9cd2ba000005dcc-d9-4c97f45b270c
Message-ID: <4C97F451.5090907@hitachi.com>
Date: Tue, 21 Sep 2010 08:54:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: Is it supported to perf probe data?
References: <AANLkTinJBUxr-GtxxMFsnn_tb-0FS9b1KOe06YiBr5En@mail.gmail.com>
In-Reply-To: <AANLkTinJBUxr-GtxxMFsnn_tb-0FS9b1KOe06YiBr5En@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luming,

(2010/09/20 17:03), Luming Yu wrote:
> Hi there,
> 
> I need to analyze accessing pattern to a data in kernel. Wanna to
> check with you if perf probe can help to get that trace.

Yes, perf probe can add new trace events which can be used
from perf record/report/trace or ftrace as same as other pre-defined
trace events. Those new events can record variables as arguments too.
So you can define new events with accessed data, record it by perf record,
and see it by perf trace.

Thank you,
-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
