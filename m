Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0LNKwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:52:03 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:39378 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0LNKwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oA8XHTH206DL7lYv3xSx5u2GxRJ8TI/H/l19AKNmgJ0LKeCEwV6Wj/4++FgkgX+PEU
         y5MwmqPWIC3SBcWfeYyaPuazFsyqBoPjut4BG4s0BaZ/L9OlKgs0ostem43dPWNjBzQw
         J+kIPAqCAOaxjr2fHgZ1gApDO7jyTqtUEiqYs=
Date: Tue, 14 Dec 2010 12:51:52 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 11/21] Track the core generation requests
Message-ID: <20101214105152.GA4834@core2.telecom.by>
References: <20101214152259.67896960@suzukikp>
 <20101214154204.21048247@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214154204.21048247@suzukikp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 03:42:04PM +0530, Suzuki K. Poulose wrote:
> --- /dev/null
> +++ linux-2.6.36-rc7/fs/proc/gencore.h

> +#include <linux/sched.h>

struct task_struct; is enough.

> +struct core_proc {
> +	struct list_head list;
> +	struct task_struct *task;
> +};
