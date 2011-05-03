Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1ECDCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 23:02:51 -0400
Received: from mail.insync.za.net ([112.109.69.121]:40833 "EHLO
	mail.insync.za.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1ECDCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 23:02:50 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 23:02:50 EDT
Date: Tue, 3 May 2011 14:57:26 +1200 (NZST)
From: Pieter De Wit <pieter@insync.za.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Detection of HyperThreading (fwd)
Message-ID: <alpine.DEB.2.02.1105031450160.2853@eragon.insync.za.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Below is a post I made to cpufreq - obviously the wrong list (Sorry guys). 
Dave has helped me, but I would like to know if I understand his reply 
correctly.

In a nutshell, what he is saying is that the HT flag is "really" a flag 
that says the CPU can report (as per Intel's site) cores vs threads ?

I am wondering if this isn't confusing for the avg Joe in the street (it 
had me going for a while) claiming that the CPU has HT, when it rather has 
the capability to report a HT core (for lack of a better description)

In other words, shouldn't/should there be something else indicating a 
certain "core" is really a HT "thread" (in /proc/cpuinfo)

(Please correct me if I mis-understood the topic/reply)

Thanks,

Pieter

---------- Forwarded message ----------
Date: Mon, 2 May 2011 12:15:57 -0400
Cc: cpufreq@vger.kernel.org
Subject: Re: Detection of HyperThreading

On Mon, May 02, 2011 at 03:47:30PM +1200, Pieter De Wit wrote:
  > Hello Guys,
  >
  > I found something quite weird over the weekend. I have a few machines that
  > claim they have HT (using cat /proc/cpuinfo). These machines doesn't
  > really support HT (both with the number of threads and Intel's website)
  >
  > I was wondering:
  >
  > a) Is this the right list to send to (Sorry if not)

no, this list is for cpu frequency scaling. linux-kernel would have been
more appropriate.

  > and
  >
  > b) How is the HT flag detected ?
  >
  > CPU's like the Core2 Duo E6300 doesn't have HT, but yet the flag is
  > displayed ? See http://ark.intel.com/Product.aspx?id=27248 for info. I can
  > send a dump of /proc/cpuinfo later from home.

the 'ht' flag in /proc/cpuinfo means "this cpu knows how to report how
many siblings it has".  On a CPU which doesn't have hyperthreading, that
number will be 0.

 	Dave

