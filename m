Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0ELT7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:59:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:46500 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab0ELT7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pzdgmaYTZ7C7uhKsLftPa/zAQzIuHkEALgQy1N6HO7ttpD1TiJx7bhGE4Z1WMG6VtG
         lIFiMtUV7pk1qXxtedRSMydGACmsuiDbJ4uIYz+X+prDapdhu0vBHCaHn9qOnB2FmT92
         FRfvLfQ0BvgJbdQBgk4S5RO5/DGoUfABCGHrA=
Date: Wed, 12 May 2010 21:59:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Taras Glek <tglek@mozilla.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: How to use perf to log page faults
Message-ID: <20100512195945.GE10028@nowhere>
References: <4BEB03B6.6080706@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEB03B6.6080706@mozilla.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 12:38:30PM -0700, Taras Glek wrote:
> Hi,
> From the docs it seems that perf may be useful for logging page faults.  
> I tried
> perf record -g -d -f -e page-faults <mycommand>
> but all I got were PERF_RECORD_MMAP events.
>
> I'm using 2.6.32. Ideally I'd like to collect fault addresses and  
> userspace stacks that caused them. Isn't this what the page-fault event  
> is for?
>
> Taras


Could you try with -c 1 ?

Otherwise, does that work on the latest kernel?

Thanks.

