Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab2CZJqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:46:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62272 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2CZJqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
Date: Mon, 26 Mar 2012 12:46:29 +0300
X-Google-Sender-Auth: l_lEaSRLviY0t8-TDcbVXa2yWpM
Message-ID: <CAOJsxLGesvvdq7tmhvs1hKXUuxD06jJrc_hRrSug8mmwiXzyKw@mail.gmail.com>
Subject: Re: [RFC PATCHSET] perf ui: Small preparation on further UI work
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 11:51 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> This is my initial work of UI generalization. As we now get GTK2 support on
> perf report, improve setup_browser() to handle it properly so that we can
> add various UI specific initialization codes to the function. At least, we
> need basic error/warning handlers ASAP to see what's going on when an error
> occurred, IMHO.
>
> I put new file setup.c under ui directory (not under util/ui) and it may or
> may not be compiled depending on the system configuration. I think it'd be
> better moving generic UI codes to the directory and TUI specific codes to
> ui/tui, and so on, so that the util directory doesn't contain any UI codes.
> But before proceeding, I'd like to listen to your opinions :).

The series looks good to me:

Acked-by: Pekka Enberg <penberg@kernel.org>

Thanks!
