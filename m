Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2JJKHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:07:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:39964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2JJKHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:07:41 -0400
Message-ID: <1349863620.7880.119.camel@twins>
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
From: Peter Zijlstra <peterz@infradead.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-numa@vger.kernel.org
Date: Wed, 10 Oct 2012 12:07:00 +0200
In-Reply-To: <50754981.80900@cn.fujitsu.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
			 <1349780256.7880.12.camel@twins>
			 <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
			 <1349815676.7880.85.camel@twins>
			 <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
		 <1349860216.7880.105.camel@twins> <507540F5.7040501@cn.fujitsu.com>
	 <1349862694.7880.114.camel@twins> <50754981.80900@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 18:10 +0800, Wen Congyang wrote:
> I use ./scripts/get_maintainer.pl, and it doesn't tell me that I should cc
> you when I post that patch. 

That script doesn't look at all usage sites of the code you modify does
it?

You need to audit the entire tree for usage of the interfaces you change
and email all relevant people for whoem you're planning to break stuff
-- preferably with a proposed fix.

That's manual work, no script will ever do this for you.
