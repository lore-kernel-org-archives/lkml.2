Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2FEShJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:37:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:50724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2FEShI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:37:08 -0400
Message-ID: <1338921419.2749.31.camel@twins>
Subject: Re: relax_domain_level boot parameter has no effect
From: Peter Zijlstra <peterz@infradead.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 20:36:59 +0200
In-Reply-To: <20120605183439.GA16819@sgi.com>
References: <20120601210348.GA22471@sgi.com>
	 <1338824262.28282.87.camel@twins> <20120604181614.GA22172@sgi.com>
	 <20120605183439.GA16819@sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 13:34 -0500, Dimitri Sivanich wrote:
> 
> I'll submit a patch shortly that should return these back to what appears to
> be their intended functionality. 

I guess removing the max check in the paramater parsing is the easiest
thing.
