Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0HRUec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:34:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab0HRUeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:34:31 -0400
Date: Wed, 18 Aug 2010 13:34:03 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@CS.Princeton.EDU>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.27.52-rc2
Message-ID: <20100818203403.GA1321@suse.de>
References: <A3F5ED84-2D61-4527-B914-3B66F645FA0E@cs.princeton.edu>
 <20100818201043.GA30299@suse.de>
 <34A84AE3-AC41-4CDD-868F-F803239CC0BF@CS.Princeton.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34A84AE3-AC41-4CDD-868F-F803239CC0BF@CS.Princeton.EDU>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 04:23:39PM -0400, "S.Çağlar Onur" wrote:
> Hi Greg,
> 
> On Aug 18, 2010, at 4:10 PM, Greg KH wrote:
> 
> > On Mon, Aug 16, 2010 at 12:38:56PM -0400, "S.Çağlar Onur" wrote:
> >> Hi,
> >> 
> >> I'm started to get following with 2.6.27.52-rc2 [1]. Just to note,
> >> this kernel is linux-vserver enabled but same patchset works fine with
> >> 2.6.27.51
> > 
> > Can you try 2.6.27.52-rc3 out?
> 
> I already synced my branch with your stable-queue earlier and the
> problematic server seems to work fine without a problem.

Wonderful, thanks so much for testing, I really appreciate it.

greg k-h
