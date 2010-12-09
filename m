Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab0LIT4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:56:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:46037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0LIT4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:56:46 -0500
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <4CF75FC2.6080108@linux.vnet.ibm.com>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
	 <4CF75FC2.6080108@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 20:56:35 +0100
Message-ID: <1291924595.6803.48.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 00:58 -0800, Corey Ashford wrote:
> So the patch mentioned above, https://lkml.org/lkml/2010/11/24/584, has 
> a bug, but since it didn't get committed, I suppose it's not a problem. 
>   If anyone is still interested, I can post a v4 of that patch. 

Yeah, I think something like that would be useful.
