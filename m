Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2DQOfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:35:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62768 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2DQOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:35:46 -0400
Date: Tue, 17 Apr 2012 11:35:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, a.p.zijlstra@chello.nl, mingo@redhat.com,
        linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCHv2] perf tools: Add 'G' and 'H' modifiers to event parsing
Message-ID: <20120417143551.GA4978@infradead.org>
References: <20120417111345.GK11918@redhat.com>
 <20120417112500.GC1650@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417112500.GC1650@m.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 17, 2012 at 01:25:00PM +0200, Jiri Olsa escreveu:
> On Tue, Apr 17, 2012 at 02:13:45PM +0300, Gleb Natapov wrote:
> > They were dropped during conversion of event parser. Add test case to
> > make sure this will not happen again.
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Thanks guys, applied and pushed out to perf/urgent.

- Arnaldo
