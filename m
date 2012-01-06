Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab2AFRxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:53:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44039 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab2AFRxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:53:00 -0500
Date: Fri, 6 Jan 2012 09:52:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH -mm] slub: debug_guardpage_minorder documentation tweak
In-Reply-To: <alpine.DEB.2.00.1112161315220.6862@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1201060952300.10460@chino.kir.corp.google.com>
References: <1321633507-13614-1-git-send-email-sgruszka@redhat.com> <alpine.DEB.2.00.1112081303100.8127@chino.kir.corp.google.com> <20111212145948.GA2380@redhat.com> <201112130021.41429.rjw@sisk.pl> <alpine.DEB.2.00.1112131640240.32369@chino.kir.corp.google.com>
 <20111216132155.GA14271@redhat.com> <20111216132349.GB14271@redhat.com> <alpine.DEB.2.00.1112161315220.6862@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011, David Rientjes wrote:

> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Andrew, this should be folded into 
> slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch 
> which should be folded into 
> slub-min-order-when-debug_guardpage_minorder-0.patch
> 

Andrew, this documentation improvement is still missing from linux-next.
