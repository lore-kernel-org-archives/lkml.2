Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2BOJFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:05:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938Ab2BOJFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:05:07 -0500
Date: Wed, 15 Feb 2012 10:04:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
Message-ID: <20120215090439.GA1664@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
 <1329236924.2293.13.camel@twins>
 <1329237838.2293.20.camel@twins>
 <1329250830.2293.24.camel@twins>
 <1329253030.2293.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329253030.2293.27.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 09:57:10PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-14 at 21:20 +0100, Peter Zijlstra wrote:
> > OK, this one works. the attributes thing wants NULL termination.
> > Thanks
> > for mentioning that Jiri. 
> 
> OK, it mostly works, except:
> 
> perf record -e "cpu/config=0x108000c0/upp" ./loop_1b_locks
> 
> doesn't seem to work...
> 
> One thing that might be nice is not having to do =1 for single bit
> fields, so that we can write: inv,edge instead of inv=1,edge=1.

ok, would you think there's any use for following behaviour:
whenever field is written without the assignment, all the field defined
bits are set.. regardless if it's sengle ot multiple bit field..

looks like this would ease the implementation a little,
not mentioning the above behaviour could be usefull ;)

jirka
