Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1AXCuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:50:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab1AXCuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:50:19 -0500
Date: Mon, 24 Jan 2011 10:53:04 +0800
From: Han Pingtian <phan@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Denis Kirjanov <dkirjanov@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110124025304.GB4694@hpt.nay.redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121132011.GA15066@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 11:20:11AM -0200, Arnaldo Carvalho de Melo wrote:
> Right, one patch doing the conversion for the whole tools/perf tree
> would be better.
> 
> Han, if you can after the patch make sure it builds in an RHEL4 machine,
> that would be great,
OK, I'll test perf/urgent on RHEL4 environments.
> 
> Thanks,
> 
> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY
