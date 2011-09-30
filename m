Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab1I3HkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:40:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:48037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab1I3HkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:40:03 -0400
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Sep 2011 09:39:19 +0200
In-Reply-To: <4E850056.1090101@gmail.com>
References: <20110929230613.GA20083@ghostprotocols.net>
	 <4E850056.1090101@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317368359.19415.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 17:33 -0600, David Ahern wrote:
> > For record that means we need to dump each per-sample_id mmap onto a
> > separate file, i.e. use a directory, etc.
> 
> That seems like a major re-write of perf. 

Well we want to go there anyway. A file per cpu stream can be a lot less
overhead than one file for all cpu streams.

