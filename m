Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab2CFNZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:25:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab2CFNZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:25:34 -0500
Message-ID: <1331040318.11248.311.camel@twins>
Subject: Re: [RFC PATCH] checkpatch: Warn on use of yield()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Miao Xie <miaox@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 06 Mar 2012 14:25:18 +0100
In-Reply-To: <4F560DA8.5040302@parallels.com>
References: <20120302112358.GA3481@suse.de>
	  <1330723262.11248.233.camel@twins>
	  <20120305121804.3b4daed4.akpm@linux-foundation.org>
	  <1330999280.10358.3.camel@joe2Laptop> <1331037942.11248.307.camel@twins>
	 <4F560DA8.5040302@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 17:14 +0400, Glauber Costa wrote:
> 
> Can't we point people to some Documentation file that explains the 
> alternatives? 

Not sure that's a finite set.. however I think we covered the most
popular ones in this thread. One could use a lkml.kernel.org link.
