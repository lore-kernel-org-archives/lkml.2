Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab0J1FYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 01:24:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39548 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab0J1FYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 01:24:01 -0400
Date: Wed, 27 Oct 2010 22:23:49 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: sonnyrao@us.ibm.com, Divy Le Ray <divy@chelsio.com>,
        Dimitris Michailidis <dm@chelsio.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb3: fix crash due to manipulating queues before
 registration
Message-ID: <20101028052349.GA21144@us.ibm.com>
References: <1288236563.2658.59.camel@edumazet-laptop>
 <1288242390-28574-1-git-send-email-nacc@us.ibm.com>
 <1288243110.2658.126.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288243110.2658.126.camel@edumazet-laptop>
X-Operating-System: Linux 2.6.35-22-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.2010 [07:18:30 +0200], Eric Dumazet wrote:
> Le mercredi 27 octobre 2010 à 22:06 -0700, Nishanth Aravamudan a écrit :
> > Hi Eric,
> > 
> > Something like the following?:
> > 
> > Thanks,
> > Nish
> 
> Yes, probably, but I dont have the hardware so cannot test.

Sorry, should have been clearer. I do have the hardware, tested with the
patch, it does work. Wanted to make sure that it made sense to the
maintainers, of course, but:

Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>

Can be added, if needed.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
