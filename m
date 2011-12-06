Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab1LFNXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:23:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933164Ab1LFNXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:23:53 -0500
Date: Tue, 6 Dec 2011 11:23:46 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] perf tools: Improve macros for struct feature_ops
Message-ID: <20111206132346.GF7059@infradead.org>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com> <1323167560-2282-10-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323167560-2282-10-git-send-email-robert.richter@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 11:32:39AM +0100, Robert Richter escreveu:
> Reducing duplication and line size by extending function names for
> print and write from a single name.

Ok, more compact.
 
- Arnaldo
