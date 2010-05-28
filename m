Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0E1VaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:30:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0E1VaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:30:18 -0400
Date: Fri, 28 May 2010 18:27:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: Perf trace event parse errors for KVM events
Message-ID: <20100528212704.GA16955@amt.cnet>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 05:42:51PM +0100, Stefan Hajnoczi wrote:
> I get parse errors when using Steven Rostedt's trace-cmd tool, too.
> 
> Any ideas what is going on here?  I can provide more info (e.g. trace
> files) if necessary.

Non standard print_format for the problematic entries?

