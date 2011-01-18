Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1ARXCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:02:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61823 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1ARXCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:02:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=seI+HrJUWGKdWD+pv9pULb5+Mb6ePcn7C5umm7T96Xupo9xIlfGA7uPaJ0zIwNYBLu
         DRk9bJE+Pcet2hYXyo1ntd2q8WiAjEl/NGvinmBg+g/nuCIQDfHNF/nyva0LIiUHHjV+
         te2kAbJF0qO7fHVybv5ocxWFmLGkukc8J+rh8=
Date: Wed, 19 Jan 2011 00:52:05 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Switch proc interfaces in kernel/ to %pK
Message-ID: <20110118225205.GA4601@p183.telecom.by>
References: <1295391078.1831.21.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295391078.1831.21.camel@dan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 05:51:18PM -0500, Dan Rosenberg wrote:
> Switch users of %p in /proc interfaces in kernel/ to %pK, to allow
> configuring the level of exposure of kernel pointers via the
> kptr_restrict sysctl.

> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c

/proc/lockdep is r--------
/proc/lockdep_chains is r--------
/proc/lock_stat is rw-------

Is this supposed to mean something?
