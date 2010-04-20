Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0DTA64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 20:58:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:58150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab0DTA6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 20:58:55 -0400
Date: Mon, 19 Apr 2010 18:00:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Salman Qazi <sqazi@google.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
Message-ID: <20100419180032.15586a90@infradead.org>
In-Reply-To: <1271703701.1676.235.camel@laptop>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	<1271317886.32749.69.camel@laptop>
	<h2u4352991a1004191020q8200399oc8e9f7d8dee934bf@mail.gmail.com>
	<1271703701.1676.235.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 21:01:41 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> Right, so the IBM folks who were looking at power aware scheduling
> were working on an interface to quantify the amount of power to save.
> 
> But their approach, was an extension of the regular power aware
> load-balancer, which basically groups tasks onto sockets so that whole
> sockets can go idle.
> 
> However Arjan explained to me that your approach, which idles the
> whole machine, has the advantage that also memory banks can go into
> idle mode and save power.
> 
> Still in the interest to cut back on power-saving interfaces it would
> be nice to see if there is anything we can do to merge these things,
> but I really haven't thought much about that yet.

one correction, this is not about power *saving*, it is about power
*capping*. Power capping is pretty much energy inefficient by
definition (and surely in practice), but it's about dealing with
reality about underdimensioned airconditioning or voltage rails....

Due to the reality that socket offlining isn't as good as idle
insertion.. I rather focus on the later...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
