Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966419Ab2EOS5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966209Ab2EOS46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:56:58 -0400
Date: Tue, 15 May 2012 20:55:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Subject: Re: [PATCH v2 2/4] coredump: ensure the fpu state is flushed for
	proper multi-threaded core dump
Message-ID: <20120515185536.GA20153@redhat.com>
References: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com> <1336692811-30576-1-git-send-email-suresh.b.siddha@intel.com> <1336692811-30576-2-git-send-email-suresh.b.siddha@intel.com> <20120511165128.GA21511@redhat.com> <1336763121.12610.13.camel@sbsiddha-desk.sc.intel.com> <20120513161117.GA6684@redhat.com> <1337105014.12610.81.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337105014.12610.81.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15, Suresh Siddha wrote:
>
> Oleg, Can I treat this as your Ack for this patch?

Not sure I can ack the change in this area ;) But yes, personally
I think this is the most simple fix for now, whatever we do later.

Acked-by: Oleg Nesterov <oleg@redhat.com>

