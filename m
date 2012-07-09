Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2GINDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:03:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:48790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2GINDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:03:16 -0400
Message-ID: <1341838984.3462.71.camel@twins>
Subject: Re: [PATCH 07/10] perf, tool: Add support to specify hw event as
 pmu event term
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 15:03:04 +0200
In-Reply-To: <CABPqkBQk7+8D9S3kAqRBz6qMZ1_Vi88XXgNF1PGb89t5bP=NRg@mail.gmail.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-8-git-send-email-jolsa@redhat.com>
	 <1341398360.2507.99.camel@laptop> <20120704120001.GC960@krava.redhat.com>
	 <1341404019.2507.107.camel@laptop>
	 <CABPqkBQk7+8D9S3kAqRBz6qMZ1_Vi88XXgNF1PGb89t5bP=NRg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 03:08 +0200, Stephane Eranian wrote:
> >> We use '_' in file names and '-' in event symbol names. I thought it might be
> >> confusing allowing just '_' so I added also the '-' version.
> >>
> What's wrong with keeping the - in the filenames as well? That would help
> keep things simple. That would avoid yet another layer of aliases. 

No idea, my fingers prefer _ but it doesn't really matter all that much.

# find /sys | grep _ | wc -l
11753
# find /sys | grep - | wc -l
3700


So sysfs prefers _ as well, but there's enough - to not be the first ;-)
