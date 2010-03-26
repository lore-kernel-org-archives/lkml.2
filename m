Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0CZRjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:39:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58653 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0CZRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Eiqxp+dd9wCfwwM3OuT4FlKSaipdi5SRPUWc2xrouyifrOrY3o4zpOZiF9YV5tj5jq
         Ss7/KEI8b7WHiPRIhHhcoJ4mJ/opGO+KKMVJTl7Cd3DI0+VoXCOEa1I+BtJWRcH/jzwV
         0roiqVgpxbZmcWx0+cd59ykUIOMy67UwblKZw=
Date: Fri, 26 Mar 2010 18:39:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
Message-ID: <20100326173911.GE5188@nowhere>
References: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com> <1269586358.12097.117.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269586358.12097.117.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 07:52:38AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-26 at 03:22 +0100, Frederic Weisbecker wrote:
> > We can't use irqsafe per cpu counters for that as
> > these stats might be also written from NMI path, and irqsafe per
> > cpu counters are not NMI safe, but local_t operations are.
> > 
> lockdep shouldn't do NMI, nmi_enter() has an explicit lockdep_off().
> 


Ah ok, thanks.

