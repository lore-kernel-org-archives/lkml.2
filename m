Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2GWSA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:00:56 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34139 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2GWSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <1343055645-24083-2-git-send-email-kirill@shutemov.name>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name> <1343055645-24083-2-git-send-email-kirill@shutemov.name>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 23 Jul 2012 14:00:33 -0400
Message-ID: <CAOPLpQe7=Gv7ToM8cqe1rNCP+vX5=gVppA1=gfaO0LSdqMhqMQ@mail.gmail.com>
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

On Mon, Jul 23, 2012 at 11:00 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> The right way to fix it is to switch to XSI-compliant version.

And why exactly would this be "the right way"?  Just fix the use of
strerror_r or use strerror_l.
