Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2BWUe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:34:27 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36672 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab2BWUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:34:26 -0500
X-Sasl-enc: TKxZbGq+f2RR81tybUr+y7Iu8ZOydIhgnJwJzgPk2ufg 1330029265
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
From: Colin Walters <walters@verbum.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Thu, 23 Feb 2012 15:33:56 -0500
In-Reply-To: <CAOJsxLEQ0VNsTEApsWQHC4G4199xm31UkWt1n0fqh3tZVa2f8A@mail.gmail.com>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	 <1330025802.17301.1.camel@lenny>
	 <CAOJsxLEQ0VNsTEApsWQHC4G4199xm31UkWt1n0fqh3tZVa2f8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1330029238.17301.3.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 22:18 +0200, Pekka Enberg wrote:
> On Thu, 2012-02-23 at 18:18 +0200, Pekka Enberg wrote:
> >> This patch adds a simple GTK2-based browser to 'perf report' that's based on
> >> the TTY-based browser in builtin-report.c.
> >>
> >> Please not that you need to use
> >>
> >>   make WERROR=0
> 
> On Thu, Feb 23, 2012 at 9:36 PM, Colin Walters <walters@verbum.org> wrote:
> > You could -Wnoerror=strict-prototypes...
> 
> Sure. We don't want to do that for all files. Just for the ones that
> include <gtk/gtk.h>.

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wstrict-prototypes"
#include <gtk/gtk.h>
#pragma GCC diagnostic pop


