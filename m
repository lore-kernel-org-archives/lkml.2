Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2CTTsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 15:48:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:37653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2CTTsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 15:48:07 -0400
Message-ID: <1332272870.18960.450.camel@twins>
Subject: Re: [PATCH 1/1] Fix number of events displayed in header
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ashay Rane <ashay.r@gmail.com>, linux-perf-users@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ashay Rane <ashay.rane@tacc.utexas.edu>
Date: Tue, 20 Mar 2012 20:47:50 +0100
In-Reply-To: <4F68DE88.1040301@gmail.com>
References: <1332271396-21756-1-git-send-email-ashay.r@gmail.com>
	 <20120320194241.GA24870@infradead.org> <4F68DE88.1040301@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 13:46 -0600, David Ahern wrote:
> 
> Does not seem appropriate to change from number of sample events to 
> period for all event types. This change assumes the event is cycles, 
> cpu-clock or task-clock. 

I'm not seeing that assumption. That said, I don't see the point of the
change either.
