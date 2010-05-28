Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab0E1Pfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:35:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54686 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0E1Pfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BAOKHsIR+2rlZcKhj/h1Mpoks+DwCPaohiR0EBCq17wR+WD7tddm6DIkJGO1zZvqU1
         k3XItfgq+rPtju3SoR4EkKedaoYSJ0xvE96jxlTaj5yoCIfx2knh+MplKHtejzSDINJo
         TlZEZVDW/xarxBBeHpieyfzjFqQJ5g2qMWLcE=
MIME-Version: 1.0
In-Reply-To: <1275060103.27810.9651.camel@twins>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
	<AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
	<20100528145329.7E2D.A69D9226@jp.fujitsu.com>
	<20100528125305.GE11364@uudg.org>
	<20100528140623.GA11041@barrios-desktop>
	<20100528143617.GF11364@uudg.org>
	<20100528151249.GB12035@barrios-desktop>
	<1275060103.27810.9651.camel@twins>
Date: Sat, 29 May 2010 00:35:50 +0900
Message-ID: <AANLkTinoTgYfywq1S6UV-n7npzk4xyQZ2PMT5LDkaBCQ@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 12:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2010-05-29 at 00:12 +0900, Minchan Kim wrote:
>> I think highest RT proirity ins't good solution.
>> As I mentiond, Some RT functions don't want to be preempted by other processes
>> which cause memory pressure. It makes RT task broken.
>
> All the patches I've seen use MAX_RT_PRIO-1, which is actually FIFO-1,
> which is the lowest RT priority.

Stupid me. I confused that until now.
That's exactly what I want.


-- 
Kind regards,
Minchan Kim
