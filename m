Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2BQXfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:35:41 -0500
Received: from numidia.opendz.org ([98.142.220.152]:41228 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab2BQXfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:35:40 -0500
Date: Sat, 18 Feb 2012 00:39:08 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>,
        pageexec@freemail.hu, spender@grsecurity.net
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Message-ID: <20120217233908.GA24047@dztty>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros>
 <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217193719.GA4187@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 11:37:19PM +0400, Vasiliy Kulikov wrote:
> pattern, otherwise it is not a true refcounter :)  It should be straightforward to
> move to kref.
> 
> 
> Moving to atomic64_t is attractive, but:
> 
> 1) we still should find all atomic_t refcounters.  Why not move to kref then?
> 
> 2) what to do with architectures-loosers?
There is lib/atomic64.c but with a static hashed array of raw_spinlocks.

> 
> Thanks,
> 
> -- 
> Vasiliy Kulikov
> http://www.openwall.com - bringing security into open computing environments
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
tixxdz
http://opendz.org
