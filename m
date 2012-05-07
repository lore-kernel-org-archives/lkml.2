Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2EGHZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:25:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46524 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2EGHZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:25:00 -0400
MIME-Version: 1.0
In-Reply-To: <1336370582-30959-2-git-send-email-namhyung.kim@lge.com>
References: <1336370582-30959-1-git-send-email-namhyung.kim@lge.com>
	<1336370582-30959-2-git-send-email-namhyung.kim@lge.com>
Date: Mon, 7 May 2012 10:17:41 +0300
X-Google-Sender-Auth: nQSFHoW1pIUkUnY6NrCSiWRAW4k
Message-ID: <CAOJsxLEo32u8iYvQ+qeBX2YSKq=ftHs2jMdsKcCWWKO07XPGHg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] perf ui/gtk: Use struct perf_error_ops
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 9:03 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Define and use perf_gtk_eops to provide a GTK2 message
> dialog for error reporting. To do that, we need global
> main_window variable for tracking UI state.
>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>

I still don't like the dialog-based approach because it requires the
*user* to respond. Just add a label to the GTK window and show the
latest message there. If you want to make it even prettier, make the
label clickable and open up a popup that shows all the warnings and
errors in a separate window...
