Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2IZFK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:10:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52697 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2IZFKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:10:25 -0400
Date: Wed, 26 Sep 2012 10:12:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [QUESTION] Can uprobe_event support @ADDR, $retval,
 offs(FETCHARG)?
Message-ID: <20120926044238.GC27339@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12092605-3534-0000-0000-00000D1E52E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hyeoncheol,

> uprobe_event only supports %REG arguments. I think that memory fetch,
> return value fetch, memory dereference functions in
> kernel/trace/trace_probe.c are good for uprobe_event.

Yes, these will be good to have and is listed as todo.

> So with a little
> modification of parse_probe_arg(), uprobe_event can support @ADDR,
> $retval, offs(FETCHARGS) except @SYM, $stack, $stackN. Is it right?

For some of these like the @sym, trace_uprobe.c may not be the right
place because the kernel will not be able to decode user space symbols. 

$retval needs uretprobes support

-- 
Thanks and Regards
Srikar

