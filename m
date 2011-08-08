Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1HHOld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:41:33 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50323 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab1HHOlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:41:31 -0400
Date: Mon, 8 Aug 2011 11:41:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix coredump caused by introduce of probe module
 option
Message-ID: <20110808144124.GA2297@ghostprotocols.net>
References: <1311602888-2389-1-git-send-email-bookjovi@gmail.com>
 <CACV3sbKNgbqX+W05mp0H0Etggext9tRx4bfPA+pT8sgudpoy5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACV3sbKNgbqX+W05mp0H0Etggext9tRx4bfPA+pT8sgudpoy5Q@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 08, 2011 at 11:01:19AM +0800, Jovi Zhang escreveu:
> On Mon, Jul 25, 2011 at 10:08 PM,  <bookjovi@gmail.com> wrote:
> > From: root <root@localhost.localdomain>
> >
> > perf will coredump if user don't give "-m" option in probe command,
> > this patch fix it.
> >
> > [root@localhost perf]# ./perf probe --add='PROBE'
> > Segmentation fault (core dumped)
> >
> > Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> > ---
> >  tools/perf/util/probe-event.c |   12 ++++++++----
> >  1 files changed, 8 insertions(+), 4 deletions(-)
> >
> 
> Hi acme,
>    Can this patch go through your tree?
>    (Get rid of "From" field, that's suck. :))

yeah, I'm applying it.

Thanks,

- Arnaldo
