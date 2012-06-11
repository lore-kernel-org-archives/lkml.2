Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2FKIdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:33:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38427 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2FKIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <4FD58C54.7050504@kernel.org>
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
	<1339325468-30614-9-git-send-email-levinsasha928@gmail.com>
	<4FD58C54.7050504@kernel.org>
Date: Mon, 11 Jun 2012 11:33:09 +0300
X-Google-Sender-Auth: t5OfJ932b6-eOVTB7JsHpWVMjL0
Message-ID: <CAOJsxLHRfkoS7ZN8bC1MYdiAWFkWV9bVNgc_hOerfUiKmFkyAg@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] mm: frontswap: add tracing support
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, dan.magenheimer@oracle.com,
        konrad.wilk@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 07:51 PM, Sasha Levin wrote:
>> Add tracepoints to frontswap API.
>>
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

On Mon, Jun 11, 2012 at 9:12 AM, Minchan Kim <minchan@kernel.org> wrote:
> Normally, adding new tracepoint isn't easy without special reason.
> I'm not sure all of frontswap function tracing would be valuable.
> Shsha, Why do you want to add tracing?
> What's scenario you want to use tracing?

Yup, the added tracepoints look more like function tracing. Shouldn't
you use something like kprobes or ftrace/perf for this?
