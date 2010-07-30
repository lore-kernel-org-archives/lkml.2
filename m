Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0G3N5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 09:57:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:59701 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab0G3N5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 09:57:09 -0400
Date: Fri, 30 Jul 2010 06:57:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-arch@vger.kernel.org
Subject: Re: [patch] Remove the per cpu tick skew
Message-ID: <20100730065714.3179df46@infradead.org>
In-Reply-To: <20100730072704.GA9960@amd>
References: <20100727210210.58d3118c@infradead.org>
	<20100730072704.GA9960@amd>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 17:27:04 +1000
Nick Piggin <npiggin@suse.de> wrote:
> > Nowadays, with the tickless kernel, this contention no longer
> > happens since time keeping and updating are done differently. In
> > addition, this skew is actually hurting power consumption in a
> > measurable way on many-core systems.
> 
> Question, how much of a win is it? What does it do that tickless
> idle does not, can you explain?

tickless idle works great if you're really almost idle

if there's "some work but not fully busy" this still matters


this is not about 'a few milliwatts', but on a server in our labs
(sorry, no hardware details in public) this effect is in the "several
dozen Watts" range.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
