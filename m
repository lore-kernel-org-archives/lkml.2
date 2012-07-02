Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2GBT7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:59:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43687 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab2GBT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:58:59 -0400
Date: Mon, 2 Jul 2012 21:58:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Improve basic Ivy Bridge support v3
Message-ID: <20120702195855.GH11413@one.firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org> <1341254598-1379-2-git-send-email-andi@firstfloor.org> <1341257194.23484.16.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341257194.23484.16.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 09:26:34PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-07-02 at 11:43 -0700, Andi Kleen wrote:
> > - As Stephane pointed out .code=0xb1, .umask=0x01 is gone from the
> > event list,
> > so don't do a generic backend stall event on IvyBridge. 
> 
> 325462-043US, May 2012:
> 
> Page 3135, Table 19-2. Non-Architectural Performance Events In the
> Processor Core of Third Generation Intel Core i7, i5, i3 Processors

The table is outdated.

But if you insist can readd it. It's just unlikely to work.

-Andi
