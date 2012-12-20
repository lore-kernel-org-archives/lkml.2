Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab2LTHDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:03:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57933 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2LTHDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:03:49 -0500
Date: Wed, 19 Dec 2012 23:03:29 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        robert.richter@amd.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] perf/POWER7: Make generic event translations
 available in sysfs
Message-ID: <20121220070323.GA16711@us.ibm.com>
References: <20121219072646.GA30580@us.ibm.com>
 <20121219072848.GB30790@us.ibm.com>
 <20121220053600.GC28007@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220053600.GC28007@kroah.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122007-3620-0000-0000-000000AF8B29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH [greg@kroah.com] wrote:
| On Tue, Dec 18, 2012 at 11:28:49PM -0800, Sukadev Bhattiprolu wrote:
| > 
| > [PATCH 3/5] perf/POWER7: Make generic event translations available in sysfs
| 
| As you are adding new sysfs files, you must also add new
| Documentation/ABI entries at the same time.  Please also do this for the
| other patches in this series that add new sysfs files.

Ok. Will wait for any other review comments on this patchset and repost with
the ABI info.

Sukadev

