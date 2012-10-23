Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2JWWdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:33:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:51727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab2JWWdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:33:09 -0400
Message-ID: <1351031574.13456.47.camel@twins>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Oct 2012 00:32:54 +0200
In-Reply-To: <20121023215907.GB24069@moon>
References: <5085B1A8.4020609@parallels.com> <20121022205641.GL2303@moon>
	 <20121022213449.GH31440@moon>
	 <20121022145158.53bddfc1.akpm@linux-foundation.org>
	 <20121023061341.GA7020@moon>
	 <20121022233025.09ec2d92.akpm@linux-foundation.org>
	 <20121023063430.GB7020@moon> <20121023071549.GC7020@moon>
	 <20121023143045.183657c4.akpm@linux-foundation.org>
	 <20121023214639.GM7020@moon> <20121023215907.GB24069@moon>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 01:59 +0400, Cyrill Gorcunov wrote:
>                 [ilog2(VM_WRITE)]       = { {'w', 'r'} },

since we're being awfully positive about crazy late night ideas, how
about something like:

#define MNEM(_VM, _mn) [ilog2(_VM)] = {(const char [2]){_mn}}

	MNEM(VM_WRITE, "wr"),


