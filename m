Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2IZHnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:43:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40120 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2IZHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:43:14 -0400
MIME-Version: 1.0
In-Reply-To: <506297A0.9070609@gmail.com>
References: <20120924162236.GA10606@quad>
	<506297A0.9070609@gmail.com>
Date: Wed, 26 Sep 2012 09:43:12 +0200
Message-ID: <CABPqkBTO94bVZs1u3PCjpmt9kMh0TwgMN1s1gQ4DWXkFXj0ENA@mail.gmail.com>
Subject: Re: [PATCH] perf record: add meta-data support for pipe-mode
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 7:50 AM, David Ahern <dsahern@gmail.com> wrote:
> I like the idea, but can't checkout the patch - does not apply to Arnaldo's
> latest perf/core branch. mind rebasing?
>
It's against tip-master.

> David
