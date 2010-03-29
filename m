Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0C2V2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:28:41 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55813 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0C2V2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tPnkvEYjT4mkKiA/3QoPhH7ZWSfiAmw+LIob/aGuoslLwCGcC2KyZQ3knSn8Px/l8V
         7TULxbERu0nUuzCe1Vx29bqITSIhvPhEvOsRVT+jhtWln3x5v/BlaNhVtvgsp9vPvE5V
         0fWEIhQjeDgY4vjBRO2/6nJu+MEW4nSdKpUOU=
Date: Mon, 29 Mar 2010 23:28:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
Message-ID: <20100329212839.GA12254@nowhere>
References: <20100329204931.GJ5101@nowhere> <20100329.140131.118617762.davem@davemloft.net> <20100329211149.GK5101@nowhere> <20100329.141920.243015356.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329.141920.243015356.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 02:19:20PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 29 Mar 2010 23:11:50 +0200
> 
> > On Mon, Mar 29, 2010 at 02:01:31PM -0700, David Miller wrote:
> >> From: Frederic Weisbecker <fweisbec@gmail.com>
> >> Date: Mon, 29 Mar 2010 22:49:33 +0200
> >> 
> >> > While building perf tools, or the kernel, or whatever, I often
> >> > get the following error in the middle:
> >> > 
> >> > 	gcc: Internal error: Segmentation fault (program as)
> >> > 
> >> > And this in the logs:
> >> > 
> >> > 	[ 1429.477049] as[2658]: segfault at 4054dfa8 ip 0000000000020690 (rpc 00000000700adcf4) sp 00000000ffcbf008 
> >> > error 30001 in as[10000+40000]
> >> 
> >> What distribution and binutils are you using?
> > 
> > It's a debian lenny, with binutils 2.18.1~cvs20080103-7.
> 
> I'm using the same here on some boxes, what kind of machine is this?


It's a Niagara 2 based one.

