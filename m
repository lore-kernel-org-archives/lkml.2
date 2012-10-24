Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2JXGah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:30:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39311 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2JXGag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:30:36 -0400
Date: Wed, 24 Oct 2012 10:30:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-ID: <20121024063032.GA30983@moon>
References: <20121022213449.GH31440@moon>
 <20121022145158.53bddfc1.akpm@linux-foundation.org>
 <20121023061341.GA7020@moon>
 <20121022233025.09ec2d92.akpm@linux-foundation.org>
 <20121023063430.GB7020@moon>
 <20121023071549.GC7020@moon>
 <20121023143045.183657c4.akpm@linux-foundation.org>
 <20121023214639.GM7020@moon>
 <20121023215907.GB24069@moon>
 <1351031574.13456.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351031574.13456.47.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:32:54AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-10-24 at 01:59 +0400, Cyrill Gorcunov wrote:
> >                 [ilog2(VM_WRITE)]       = { {'w', 'r'} },
> 
> since we're being awfully positive about crazy late night ideas, how
> about something like:
> 
> #define MNEM(_VM, _mn) [ilog2(_VM)] = {(const char [2]){_mn}}
> 
> 	MNEM(VM_WRITE, "wr"),

I see no reason why should not we :) I'll update.
