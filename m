Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2A3S4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:56:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60443 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2A3S4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:56:09 -0500
Date: Mon, 30 Jan 2012 16:56:01 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] perf record: Add error message for EMFILE
Message-ID: <20120130185601.GD15935@infradead.org>
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
 <1327827356-8786-2-git-send-email-namhyung@gmail.com>
 <4F256587.3090504@gmail.com>
 <4F25EDCC.3010800@gmail.com>
 <CAKYOsXxxmG8xQfPcn9xW+Dzd_-Qo8jUv8071UHdC18RBatq=uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYOsXxxmG8xQfPcn9xW+Dzd_-Qo8jUv8071UHdC18RBatq=uw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 29, 2012 at 07:10:08PM -0700, David Ahern escreveu:
>    On Jan 29, 2012 6:09 PM, "Namhyung Kim" <namhyung@gmail.com> wrote:
>    > 2012-01-30 12:28 AM, David Ahern wrote:
>    > Right. How about this then? If it looks OK to you, I'll resend the patch
>    for record, top, stat:
>    >
>    >
>    >        Too many events are opened.
>    >        Try again after reducing the number of events,
>    >        tasks and/or cpus.
> 
>    Looks ok to me.

Ok, waiting for the resend,

- Arnaldo
