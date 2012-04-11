Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab2DKCvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 22:51:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52781 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab2DKCvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 22:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120410224543.GA11433@windriver.com>
References: <20120410224543.GA11433@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 10 Apr 2012 22:50:44 -0400
Message-ID: <CAMjpGUetfGQxqTKVfLBtOdthxFtFv-knuXSWoNx0BKxJd=829Q@mail.gmail.com>
Subject: Re: linux-next: triage for April 10, 2012
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 18:45, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> bfin: 50% of builds
>        when:   Mar 31
>        why:    "Error: pcrel too far BFD_RELOC_BFIN_10" from kernel/time/timekeeping.c
>        status: unknown, binutils issue?
>        fix:
>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5981475/

that log file doesn't say anything about "BFD_RELOC_BFIN_10"

it does show the old L1 data overflow though ...

on a side note, the warning:
arch/blackfin/mm/init.c:79:9: warning: array subscript is above array
bounds [-Warray-bounds]
is a bad thing, but i've just pushed a fix for that ...
-mike
