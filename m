Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2BQA0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:26:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2BQA0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:26:04 -0500
Date: Thu, 16 Feb 2012 16:26:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] make vfork() killable
Message-Id: <20120216162602.386cadf9.akpm@linux-foundation.org>
In-Reply-To: <20120216172626.GA30393@redhat.com>
References: <20120214164709.GA21178@redhat.com>
	<20120214164914.GF21185@redhat.com>
	<20120215123049.6e938eed.akpm@linux-foundation.org>
	<20120216150429.GB11953@redhat.com>
	<20120216172626.GA30393@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 18:26:26 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 02/16, Oleg Nesterov wrote:
> >
> > Btw, there is another example of "unbounded" sleep in UNINTERRUPTIBLE,
> > vfork. I already have the patches, will send today.
> 
> Make vfork() killable, please apply.
> 
> These patches are old (Aug 2011), they spent a lot of time in linux-next
> without any problem. Linus participated in the discussion, iiuc he has
> no objections.

hum.  Via which tree did they get into linux-next and why did they not
get any further?

