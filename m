Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2GWWDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 18:03:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64626 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2GWWDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 18:03:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120723210654.GA25248@shutemov.name>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
 <1343055645-24083-2-git-send-email-kirill@shutemov.name> <CAOPLpQe7=Gv7ToM8cqe1rNCP+vX5=gVppA1=gfaO0LSdqMhqMQ@mail.gmail.com>
 <20120723203120.GA25072@shutemov.name> <CAOPLpQdcSw6KGT=odFSAUScd44mUdkYpR6hQM_zg81Y88T=VHg@mail.gmail.com>
 <20120723210654.GA25248@shutemov.name>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 23 Jul 2012 18:03:24 -0400
Message-ID: <CAOPLpQeLKYvonWXY-WSZt+DL_OoChyAqYm7nzNUSq7kumtUhZA@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: use XSI-complaint version of strerror_r()
 instead of GNU-specific
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 5:06 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> They are bugs.
>
> Let's fix strerror_r() usage.
>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Acked-by: Ulrich Drepper <drepper@gmail.com>
