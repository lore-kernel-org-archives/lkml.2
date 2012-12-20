Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2LTFbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:31:37 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57250 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2LTFbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:31:31 -0500
Date: Wed, 19 Dec 2012 21:34:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/3] perf x86: Add precise sysfs attribute
Message-ID: <20121220053430.GB28007@kroah.com>
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
 <1355929642-28392-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355929642-28392-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 04:07:21PM +0100, Jiri Olsa wrote:
> Adding sysfs precise attribute for cpu device (/sys/devices/cpu)
> to show the maximum value for perf event precise attribute.
> 
> This will be initialy used for automated precise event perf test
> and could be helpful otherwise. Arnaldo suggested to use this as
> a guide for default adding of precise attribute for HW events.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)

As you are adding a new sysfs file, you must also document it with an
entry in Documentation/ABI/

thanks,

greg k-h
