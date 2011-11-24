Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1KXLDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:03:37 -0500
Received: from ns2.q-leap.de ([88.79.172.217]:47209 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab1KXLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:03:35 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Nov 2011 06:03:35 EST
Message-ID: <4ECE222B.2030104@q-leap.de>
Date: Thu, 24 Nov 2011 11:53:31 +0100
From: Peter Kruse <pk@q-leap.de>
Organization: Q-Leap Networks GmbH
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
        David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
References: <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com> <4DA54D2A.3050206@q-leap.de> <alpine.DEB.2.00.1104131116330.19493@router.home> <4E09BEA1.1080501@q-leap.de> <alpine.DEB.2.00.1107051013500.16869@router.home> <20110705172043.GA15147@csn.ul.ie> <20110706041602.GX1026@dastard> <4E1405C3.20904@q-leap.de> <alpine.DEB.2.00.1107060931190.17202@router.home> <4E147C0A.4080008@q-leap.de> <alpine.DEB.2.00.1107061030190.17624@router.home>
In-Reply-To: <alpine.DEB.2.00.1107061030190.17624@router.home>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On 07/06/2011 05:30 PM, Christoph Lameter wrote:
> On Wed, 6 Jul 2011, Peter Kruse wrote:
> 
>>> Note that this is *not* the original problem you reported. I do not see
>>> page alloc failures in your latest logs.
>>>
>>
>> yes, I see.  Maybe originally there were two problems of which one is
>> now solved?
> 
> That could be the case. Please run the latest 2.6.32 as requested by Mel.
> 

the problem seems to be solved indeed.  The server now has an uptime
of 50 days without any problems where it crashed in the past
after at most 42 days.

Thank you all,

  Peter
