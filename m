Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2FTQnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:43:32 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43919 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab2FTQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:43:30 -0400
Message-ID: <4FE1FD93.9050508@us.ibm.com>
Date: Wed, 20 Jun 2012 09:42:59 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>, Jonathan Nieder <jrnieder@gmail.com>,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
References: <4FDB8563.3030805@us.ibm.com> <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk> <20120617164751.GJ12429@burratino> <20120617173456.GA3684@netboy.at.omicron.at> <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk> <20120618162854.GA3111@netboy.at.omicron.at> <1340106888.6871.20.camel@deadeye.wl.decadent.org.uk> <4FE0B659.9090604@us.ibm.com> <20120620162528.GB2180@netboy.at.omicron.at>
In-Reply-To: <20120620162528.GB2180@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062016-1976-0000-0000-00000E5D0F33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 09:25 AM, Richard Cochran wrote:
> On Tue, Jun 19, 2012 at 10:26:49AM -0700, John Stultz wrote:
>> Richard, are you planning on taking another go at those changes? Or
>> were my last suggestions just too daft? ;)
> I wonder if it is really worth the effort to fix up adjtimex.
>
> But I am strongly in favor of adding CLOCK_TAI, since that would be
> easy to add (as you showed), is free from the tick issue, and would be
> really useful for Test and Measurement style applications
I've got the CLOCK_TAI patches queued for 3.6. I should send them to 
-tip soon here.

thanks
-john

