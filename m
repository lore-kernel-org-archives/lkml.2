Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0F1PkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:40:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:43788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0F1PkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:40:03 -0400
Date: Mon, 28 Jun 2010 17:40:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
Message-ID: <20100628154002.GB24127@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
 <4C2417AA.4030306@us.ibm.com>
 <20100625082711.GA32765@tiehlicka.suse.cz>
 <4C24ED34.9040808@us.ibm.com>
 <4C253D32.6040304@us.ibm.com>
 <20100628144246.GA14201@tiehlicka.suse.cz>
 <20100628153214.GA24127@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628153214.GA24127@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-06-10 17:32:14, Michal Hocko wrote:
[...]
> Btw. I guess that there is a typo in the condition and it should be
> like this:
> 	if (cred->euid != pcred->euid &&
> -		    cred->euid != pcred->uid)
> + 		    cred->uid != pcred->uid)

Scratch that. This looks correct.


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
