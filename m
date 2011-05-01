Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1EAKUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 06:20:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36560 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab1EAKUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 06:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CXEgZc9k40raxV/xOxDetzcJkH93rMh5V0qPYQgqE4Fu94+jTKVtqrOVpLJNF6E97Y
         bbIxAdqYxyv5v/Kx+qrqJo98d5lQwGBQIjIHspG/tMME425HvXZWYs7E9sxBqneSJ2tC
         nIeRCpmvrP8pxxtRRA94KEBarst1h5hYEDvBs=
Date: Sun, 1 May 2011 12:20:40 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, NUMA: Fix empty memblk detection in
 numa_cleanup_meminfo()
Message-ID: <20110501102040.GM29280@htj.dyndns.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
 <4DBB1C16.3070307@kernel.org>
 <20110430121734.GF29280@htj.dyndns.org>
 <20110430123330.GG29280@htj.dyndns.org>
 <4DBCACAA.2080902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBCACAA.2080902@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 30, 2011 at 05:43:22PM -0700, Yinghai Lu wrote:
> this one works too
> but print out is some strange
> on 512g system got:
> 
> NUMA: Initialized distance table, cnt=8
> NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
> NUMA: Node 0 [0,80000000) + [100000000,1080000000) -> [0,1000000000)
> 
> 
> first patch on 512g system got 
> NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
> NUMA: Node 0 [0,80000000) + [100000000,1000000000) -> [0,1000000000)
> 
> still thinking first one is more clean.

Yeah, I don't object to the change (it's easier to understand too) but
it should be a separate patch because it's unrelated change to the fix
itself.  If you don't mind sending the splitting part separately, I'll
put it on top of the patchset.

Thanks.

-- 
tejun
