Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2CULyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:54:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:48718 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2CULyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:54:45 -0400
Message-ID: <1332330868.18960.483.camel@twins>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 21 Mar 2012 12:54:28 +0100
In-Reply-To: <20120320223636.GB1549@m>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
	 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
	 <1332269081.18960.444.camel@twins> <20120320223636.GB1549@m>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 23:36 +0100, Jiri Olsa wrote:
> > If so, we need some option like:
> > 
> >   perf record -e "{cpu-clock,cache-misses,cache-references}:1"
> > 
> > to mean, only sample on cpu-clock but use PERF_SAMPLE_READ and
> > PERF_FORMAT_GROUP to read all siblings on every cpu-clock sample.
> 
> never happy, are you.. ;) seems like nice feature, will check 

Hehe, its a long standing feature request. Also tglx asked for it only a
few days ago.

I just saw a good opportunity ;-)
