Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab0LMWiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:38:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:45708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0LMWiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:38:50 -0500
Subject: Re: [patch] perf: off by one in perf_swevent_init()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dan Carpenter <error27@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20101213194641.GH1620@bicker>
References: <20101024195041.GT5985@bicker>  <20101213194641.GH1620@bicker>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 23:38:15 +0100
Message-ID: <1292279895.6803.688.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 22:46 +0300, Dan Carpenter wrote:
> On Sun, Oct 24, 2010 at 09:50:42PM +0200, Dan Carpenter wrote:
> > The perf_swevent_enabled[] array has PERF_COUNT_SW_MAX elements.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Ping.

Thanks for the reminder, queued!
