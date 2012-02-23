Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2BWUSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:18:08 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45110 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab2BWUSF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:18:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.182.89.65 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330025802.17301.1.camel@lenny>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	<1330025802.17301.1.camel@lenny>
Date: Thu, 23 Feb 2012 22:18:05 +0200
X-Google-Sender-Auth: vufV8MmgLhgWD8pqlBoBVZO8f6o
Message-ID: <CAOJsxLEQ0VNsTEApsWQHC4G4199xm31UkWt1n0fqh3tZVa2f8A@mail.gmail.com>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
From: Pekka Enberg <penberg@kernel.org>
To: Colin Walters <walters@verbum.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 18:18 +0200, Pekka Enberg wrote:
>> This patch adds a simple GTK2-based browser to 'perf report' that's based on
>> the TTY-based browser in builtin-report.c.
>>
>> Please not that you need to use
>>
>>   make WERROR=0

On Thu, Feb 23, 2012 at 9:36 PM, Colin Walters <walters@verbum.org> wrote:
> You could -Wnoerror=strict-prototypes...

Sure. We don't want to do that for all files. Just for the ones that
include <gtk/gtk.h>.
