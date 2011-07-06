Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1GFPPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:15:25 -0400
Received: from ns2.q-leap.de ([88.79.172.217]:34399 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab1GFPPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:15:24 -0400
Message-ID: <4E147C0A.4080008@q-leap.de>
Date: Wed, 06 Jul 2011 17:15:22 +0200
From: Peter Kruse <pk@q-leap.de>
Organization: Q-Leap Networks GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
        David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
References: <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com> <4DA54D2A.3050206@q-leap.de> <alpine.DEB.2.00.1104131116330.19493@router.home> <4E09BEA1.1080501@q-leap.de> <alpine.DEB.2.00.1107051013500.16869@router.home> <20110705172043.GA15147@csn.ul.ie> <20110706041602.GX1026@dastard> <4E1405C3.20904@q-leap.de> <alpine.DEB.2.00.1107060931190.17202@router.home>
In-Reply-To: <alpine.DEB.2.00.1107060931190.17202@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/06/2011 04:31 PM, Christoph Lameter wrote:
> On Wed, 6 Jul 2011, Peter Kruse wrote:
> 
>> Ok then I think we will schedule a kernel update and if the
>> server then runs for more than 40 days we could say that
>> the problem is fixed.
> 
> Note that this is *not* the original problem you reported. I do not see
> page alloc failures in your latest logs.
> 

yes, I see.  Maybe originally there were two problems of which one is
now solved?

Regards,

  Peter
