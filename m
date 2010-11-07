Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0KGWHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:07:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52376 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0KGWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:07:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lZnLBmXBEDDBTNKmw71wv83b0IbP9NxpO6nqeDvor74hTk16/fsQfpvIsDCUKnzqmX
         6kCxJjtlylc/shXsQN2vn8M5fgmkXXBt0ybDSQAN2sTDj09qPk1iYxaAM1r5JCPO2Po7
         JHWdWE8c5A4lG8k6TQFYqapZbjocSDvcvzuQk=
Date: Mon, 8 Nov 2010 01:07:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        paulus@samba.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        CoreyAshford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRAFT PATCH 0/3] perf: Add Intel Nehalem uncore pmu support
Message-ID: <20101107220742.GL6731@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 03:27:38PM +0800, Lin Ming wrote:
> Hi, all
> 
> Here is the draft patch to add Intel Nehalem uncore pmu support.
> It's not fully functional, but I threw it out early to get comments.
> 

 Hi Ming, sorry for late response, though there are already a lot
of comments anyway :) Great job!

 Cyrill
