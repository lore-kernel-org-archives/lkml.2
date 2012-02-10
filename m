Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab2BJT3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:29:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60877 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2BJT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:29:08 -0500
Date: Fri, 10 Feb 2012 17:29:01 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
Message-ID: <20120210192901.GK2526@infradead.org>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
 <1328894901.25989.20.camel@laptop>
 <CAKbGBLi268_o25h31SEdt=+QfzkQc+WT_oz9=hnQ--hmgJF8bQ@mail.gmail.com>
 <CAKbGBLgj-k7=Oqy8JD1Dcuj_YRjP3H_7nV9a4Q8fCaMmyA5LTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKbGBLgj-k7=Oqy8JD1Dcuj_YRjP3H_7nV9a4Q8fCaMmyA5LTA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 10, 2012 at 11:27:23AM -0800, Steven Noonan escreveu:
> > [  160.172856] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> > [  160.172984] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
> 
> It actually gets even more interesting. Once I did 'perf test' under
> Xen, and I waited for it to finish, perf suddenly works fine. I can
> re-run 'perf test -v 3' with no hangs, and can now run 'perf top' with
> no issue. Bizarre.

Heck, I keep wishing people use perf test more often to figure out bugs
sooner, but this side effect was surprising! ;-)

- Arnaldo
