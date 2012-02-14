Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab2BNVrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:47:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487Ab2BNVr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:47:29 -0500
Date: Tue, 14 Feb 2012 19:47:08 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: Re: [PATCH v6 13/18] perf: add support for taken branch sampling
	to perf report
Message-ID: <20120214214708.GC27941@infradead.org>
References: <1328826068-11713-1-git-send-email-eranian@google.com> <1328826068-11713-14-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328826068-11713-14-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 09, 2012 at 11:21:03PM +0100, Stephane Eranian escreveu:
> From: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> 
> This patch adds support for taken branch sampling, i.e, the
> PERF_SAMPLE_BRANCH_STACK feature to perf report. In other
> words, to display histograms based on taken branches rather
> than executed instructions addresses.
> 
> The new option is called -b and it takes no argument. To
> generate meaningful output, the perf.data must have been
> obtained using perf record -b xxx ... where xxx is a branch
> filter option.
> 
> The output shows symbols, modules, sorted by 'who branches
> where' the most often. The percentages reported in the first
> column refer to the total number of branches captured and
> not the usual number of samples.
> 
> Here is a quick example.
> Here branchy is simple test program which looks as follows:

Thanks for addressing the comments, looks good now,

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
