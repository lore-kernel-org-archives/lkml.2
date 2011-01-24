Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1AXEMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:12:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1AXEMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:12:33 -0500
Date: Mon, 24 Jan 2011 12:15:20 +0800
From: Han Pingtian <phan@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Denis Kirjanov <dkirjanov@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110124041520.GC4694@hpt.nay.redhat.com>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Denis Kirjanov <dkirjanov@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	paulus@samba.org
References: <20110120093246.GA8031@hera.kernel.org>
 <20110120114719.GD23661@elte.hu>
 <4D385866.3060405@kernel.org>
 <20110120172218.GB13482@ghostprotocols.net>
 <20110121085721.GD2994@hpt.nay.redhat.com>
 <20110121132011.GA15066@ghostprotocols.net>
 <20110124025304.GB4694@hpt.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124025304.GB4694@hpt.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:53:04AM +0800, Han Pingtian wrote:
> On Fri, Jan 21, 2011 at 11:20:11AM -0200, Arnaldo Carvalho de Melo wrote:
> > Right, one patch doing the conversion for the whole tools/perf tree
> > would be better.
> > 
> > Han, if you can after the patch make sure it builds in an RHEL4 machine,
> > that would be great,
> OK, I'll test perf/urgent on RHEL4 environments.
> > 
I have tested on RHEL4, the building works fine.
> > Thanks,
> > 
> > - Arnaldo

-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY
