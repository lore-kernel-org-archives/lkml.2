Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1JGRZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:25:36 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:53224 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750753Ab1JGRZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:25:33 -0400
Message-ID: <4E8F3605.6060104@localhost>
Date: Fri, 07 Oct 2011 10:25:25 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [ANNOUNCE] 3.0.6-rt17
References: <alpine.LFD.2.02.1110070046270.3240@ionos>
In-Reply-To: <alpine.LFD.2.02.1110070046270.3240@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 06:15 PM, Thomas Gleixner wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0.6-rt17 release.

Hi and thanks again. So far this one is not hanging which is very good 
news. But I still see the hrtimer_fixup_activate warnings I reported for 
rt16...

-- Fernando


> After chasing weird RCU stalls and hung task messages for quite some
> time a massive collaborative effort was able to track down and fix
> this showstopper. Explanation from the changelog:
...
