Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0DWQGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:06:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:56683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab0DWQG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:06:27 -0400
Date: Fri, 23 Apr 2010 09:08:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100423090819.4273b327@infradead.org>
In-Reply-To: <201004231050.10667.trenn@suse.de>
References: <20100418115949.7b743898@infradead.org>
	<20100423052439.GB4829@ucw.cz>
	<20100423053858.GE7798@1wt.eu>
	<201004231050.10667.trenn@suse.de>
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

On Fri, 23 Apr 2010 10:50:10 +0200
Thomas Renninger <trenn@suse.de> wrote:
 Especially on battery, users will appreciate some minutes
> of more battery lifetime and do not care about some ms of IO
> latencies. 

the assumption that power doesn't matter on AC is a huge fiction
that any data center operator would love to get out of everyones head
as quickly as possible.




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
