Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1A0O6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:58:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:40430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1A0O6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:58:14 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296138503.15234.220.camel@laptop>
References: <20101108145725.GA3434@redhat.com>
	 <20110119182141.GA12183@redhat.com> <20110120193033.GA13924@redhat.com>
	 <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu>
	 <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com>
	 <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere>
	 <20110124114234.GA12166@redhat.com>  <20110126175322.GA28617@redhat.com>
	 <1296134077.15234.161.camel@laptop>  <1296138503.15234.220.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 15:58:55 +0100
Message-ID: <1296140335.15234.221.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 15:28 +0100, Peter Zijlstra wrote:
> 
> <crazy idea here> 
> 

> So I've likely fallen off a cliff somewhere along the line, but just in
> case, here's the patch: 

Its completely broken, ignore this :-)
