Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1F3Eif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:38:35 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:37648 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1F3Ei2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:38:28 -0400
Date: Thu, 30 Jun 2011 10:07:59 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        thomas.abraham@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110630043759.GA12667@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110629130038.GA7909@in.ibm.com>
 <1309367184.11430.594.camel@nimitz>
 <20110629174220.GA9152@in.ibm.com>
 <1309370342.11430.604.camel@nimitz>
 <20110629181755.GG3646@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629181755.GG3646@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:47:55PM +0530, Vaidyanathan Srinivasan wrote:
> * Dave Hansen <dave@linux.vnet.ibm.com> [2011-06-29 10:59:02]:
> 
> > On Wed, 2011-06-29 at 23:12 +0530, Ankita Garg wrote:
> 
> > > 	5. Being able to group these pieces of hardware for purpose of
> > > 	   higher savings. 
> > 
> > Do you really mean group, or do you mean "turn as many off as possible"?
> 
> Grouping based on hardware topology could help save more power at
> higher granularity.  In most cases just turning as many off as
> possible will work.  But the design should allow grouping based on
> certain rules or hierarchies.
>

For instance, on the Samsung Exynos 4210 board, the controller
dynamically transitions 512MB of memory into lower powerdown state
depending on whether it is being actively referenced or not.
Additionally, if two such 512MB devices are free (as hinted by
software), the controller can cut the clock going into that memory
channel to which the two devices are connected, further reducing the
power consumption.
 
-- 
Regards,
eAnkita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
