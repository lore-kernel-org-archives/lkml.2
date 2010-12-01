Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0LATat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:30:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:37170 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab0LATaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:30:07 -0500
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4CF6A064.9030807@linux.vnet.ibm.com>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
	 <1291203990.4023.16.camel@twins>  <4CF6A064.9030807@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 20:30:16 +0100
Message-ID: <1291231816.32004.1953.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 11:22 -0800, Corey Ashford wrote:
> 
> With that in mind, would it still make sense to try out your tracepoint 
> patch? 

Probably not.. 
