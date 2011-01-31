Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1AaQHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:07:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45786 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1AaQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:07:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MIOE0g1F3pHqnkR0Kt4NPZiYclUAhk2gzefFkKY2B5bXztediR3XsI97NwjfqrVaCw
         svVfFhe6js2/vtEiaphgghrSMmUy4np+6LYhKOHmZIcBcPYwitNZc5KedM/A78X/VZRb
         cooMXSN0fbixDYZxHGM4ZDWOSmKvSqNAUdecs=
Date: Mon, 31 Jan 2011 17:07:24 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110131160724.GO7459@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <20110118021417.D347A1807B7@magilla.sf.frob.com>
 <20110127154600.GE24925@htj.dyndns.org>
 <20110127174857.GG24925@htj.dyndns.org>
 <20110128204030.52D31183C1E@magilla.sf.frob.com>
 <20110131154117.GK7459@htj.dyndns.org>
 <20110131155411.GA1613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131155411.GA1613@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 31, 2011 at 04:54:11PM +0100, Oleg Nesterov wrote:
> Are you sure late-ptrace-may-attach-check hangs? Perhaps it is the next
> one, tracer-lockup-on-sighandler-kill, it needs a lot of time to finish.
> IIRC, some time ago I did the testing with your patches applied (under
> kvm), I didn't notice anything unexpected.
> 
> Unfortunately, these tests are more or less "random", usually a new
> test-case appears when we find a bug.

I thought it was the first one but might be mistaken.  I left it
running for a couple of minutes several times but maybe it just needs
more time.  I'll try again.

Thanks.

-- 
tejun
