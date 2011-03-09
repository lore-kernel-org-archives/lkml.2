Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1CIP0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:26:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1CIP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:26:30 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=0z9LUEGl_CsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=rjBTMbYc3eRkWTGjqqsA:9 a=6ffwhIsm8y8Tv-wgk01bm8rZlKwA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 9 Mar 2011 10:26:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
Message-ID: <20110309152628.GA10907@home.goodmis.org>
References: <1299639487.22236.256.camel@pasglop>
 <1299665998.2308.2753.camel@twins>
 <1299670429.2308.2834.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299670429.2308.2834.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 12:33:49PM +0100, Peter Zijlstra wrote:
> 
> That is of course aside from the fact that we have a real bug there that
> needs fixing, but really guys, WTF!

They just wanted to give you a very nice reproducer for that bug ;)

-- Steve

