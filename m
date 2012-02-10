Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab2BJTH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:07:27 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:45651 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759878Ab2BJTHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:07:25 -0500
Date: Fri, 10 Feb 2012 14:04:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, ben@guthro.net
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
Message-ID: <20120210190412.GB12975@phenom.dumpdata.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
 <1328894901.25989.20.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328894901.25989.20.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F356AE2.0111,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 06:28:21PM +0100, Peter Zijlstra wrote:
> On Thu, 2012-02-09 at 18:32 -0800, Steven Noonan wrote:
> > [   88.517599]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
> 
> This looks like its waiting for an IPI to complete.. 

Hmm, Ben you tried some kdb debugging using Xen and ran in some IPI issues
didn't you? Do you remember what was the problem?

> 
> There's no actual BUGS or WARNs in the output, just the soft lockup
> thing saying things are taking a bit of time (clearly 15s waiting for an
> IPI isn't quite normal).
> 
> I've no idea why this wouldn't work on Xen, nor do the trace have any
> Xen specific muck in them.

