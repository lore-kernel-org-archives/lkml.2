Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2FTQZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:25:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61038 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2FTQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:25:40 -0400
Date: Wed, 20 Jun 2012 18:25:28 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Jonathan Nieder <jrnieder@gmail.com>,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
Message-ID: <20120620162528.GB2180@netboy.at.omicron.at>
References: <4FDB8563.3030805@us.ibm.com>
 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
 <20120617164751.GJ12429@burratino>
 <20120617173456.GA3684@netboy.at.omicron.at>
 <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
 <20120618162854.GA3111@netboy.at.omicron.at>
 <1340106888.6871.20.camel@deadeye.wl.decadent.org.uk>
 <4FE0B659.9090604@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE0B659.9090604@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 10:26:49AM -0700, John Stultz wrote:
> 
> Richard, are you planning on taking another go at those changes? Or
> were my last suggestions just too daft? ;)

I wonder if it is really worth the effort to fix up adjtimex.

But I am strongly in favor of adding CLOCK_TAI, since that would be
easy to add (as you showed), is free from the tick issue, and would be
really useful for Test and Measurement style applications

Thanks,
Richard
