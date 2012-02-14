Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117Ab2BNU51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:57:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34108 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760922Ab2BNU50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:57:26 -0500
Message-ID: <1329253030.2293.27.camel@twins>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Tue, 14 Feb 2012 21:57:10 +0100
In-Reply-To: <1329250830.2293.24.camel@twins>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1329236924.2293.13.camel@twins> <1329237838.2293.20.camel@twins>
	 <1329250830.2293.24.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 21:20 +0100, Peter Zijlstra wrote:
> OK, this one works. the attributes thing wants NULL termination.
> Thanks
> for mentioning that Jiri. 

OK, it mostly works, except:

perf record -e "cpu/config=0x108000c0/upp" ./loop_1b_locks

doesn't seem to work...

One thing that might be nice is not having to do =1 for single bit
fields, so that we can write: inv,edge instead of inv=1,edge=1.


