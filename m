Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2HHLdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:33:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab2HHLc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:32:59 -0400
Date: Wed, 8 Aug 2012 13:32:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>, acme@redhat.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv4 0/4] perf tool: Add new event group management
Message-ID: <20120808113232.GA959@krava.brq.redhat.com>
References: <1342734837-1825-1-git-send-email-jolsa@redhat.com>
 <87629i3lc2.fsf@sejong.aot.lge.com>
 <20120720093317.GA3566@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720093317.GA3566@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 11:33:17AM +0200, Jiri Olsa wrote:
> On Fri, Jul 20, 2012 at 05:09:33PM +0900, Namhyung Kim wrote:

SNIP

> > Thanks for keeping working on this. You can add my
> > 
> >   Reviewed-by: Namhyung Kim <namhyung@kernel.org>
> > 
> > for all of the patches if you want.
> > 
> 
> great, thanks!
> 
> > Btw, is it all of your user-space changes?
> 
> I have changes for the group leader sampling, which needs more testing..
> also maybe some redo after I saw your hist changes.. ;)
> 
> jirka

hi,

any other feedback on this? 
you can check rebased version (on Arnaldo's perf/core) here:

git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/group1

thanks,
jirka
