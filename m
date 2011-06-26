Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1FZKWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 06:22:46 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63185 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1FZKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 06:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kiVM6J0gbUKsGo8dTdbbLA4qYrwmIobKa9qckqV76EMaggx1BUSxdOQD52w4uT/GZn
         bbfAhFAz+yPHmFF2uu7c52EJSi2LetrZmw8jtbL/r7LrIBgzHlo64HWSIkRnGISMnKdy
         jiYUsksABixAQ5Rka1VPor0Qq1BNXFDbnyt6I=
Date: Sun, 26 Jun 2011 12:22:35 +0200
From: Tejun Heo <tj@kernel.org>
To: Conny Seidel <conny.seidel@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110626102235.GC12200@mtj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 21, 2011 at 05:41:31PM +0200, Conny Seidel wrote:
> the commit 797390d8554b1e07aabea37d0140933b0412dba0 breaks 32bit on AMD
> with native NUMA and fakeNUMA.
> 
> Native NUMA still boots, when the kernel parameter numa=off is added to
> the cmdline.

I've been looking at it without much success yet.  Can you please
attach full kernel boot log and .config?

Thanks.

-- 
tejun
