Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1A0PqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:46:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36863 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1A0PqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x2UH0Onvn3khoG2aPWSB7XfcDa3NWXMPCLs0OZmkNXnFry0/TO/AM6oAlFwETa5otI
         5kAGIzm5R3zuU4XfioubFgsPtYNAAj1nYA6u9N9OGyWXiXrnkXHL04ywpZOR8qxxD9Qk
         Gh6Em4WnYBRcX71G9tVGgWgGfh9DaDc7RdmoU=
Date: Thu, 27 Jan 2011 16:46:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110127154600.GE24925@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <20110118021417.D347A1807B7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118021417.D347A1807B7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 06:14:17PM -0800, Roland McGrath wrote:
> Oh, and for any kind of ptrace changes, please always run the whole
> ptrace-tests suite before and after.  That is by no means an exhaustive
> test that you haven't introduced new problems.  But if you introduce
> regressions in that suite, it is quite like that you are causing problems
> for existing ptrace users like gdb (even if some tests were racy before,
> if the real-world practical results change, it could be a problem).
> 
> http://sourceware.org/systemtap/wiki/utrace/tests has the pointers.

Alright, will try to do that.

Thanks.

-- 
tejun
