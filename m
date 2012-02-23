Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2BWThM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:37:12 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52133 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab2BWThL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:37:11 -0500
X-Sasl-enc: jJG7t5Eiy7ViIXqhHZYRQs6EOx3BZtsVaUXCpTkOyrs9 1330025830
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
From: Colin Walters <walters@verbum.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Thu, 23 Feb 2012 14:36:41 -0500
In-Reply-To: <1330013922-3332-1-git-send-email-penberg@kernel.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1330025802.17301.1.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 18:18 +0200, Pekka Enberg wrote:
> This patch adds a simple GTK2-based browser to 'perf report' that's based on
> the TTY-based browser in builtin-report.c.
> 
> Please not that you need to use
> 
>   make WERROR=0

You could -Wnoerror=strict-prototypes...

> 
> to build perf on Fedora 15 (and possibly other distributions) because GTK
> headers do not compile cleanly:
> 
>       CC util/gtk/browser.o
>   In file included from /usr/include/gtk-2.0/gtk/gtk.h:234:0,
>                    from util/gtk/browser.c:7:
>   /usr/include/gtk-2.0/gtk/gtkitemfactory.h:47:1: warning: function declaration isn’t a prototype [-Wstrict-prototypes]

Unfortunately it was a historical mistake, but it's part of the public
API:

https://bugzilla.gnome.org/show_bug.cgi?id=508760

