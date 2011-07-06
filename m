Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1GFGut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:50:49 -0400
Received: from ns2.q-leap.de ([88.79.172.217]:39733 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1GFGus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:50:48 -0400
Message-ID: <4E1405C3.20904@q-leap.de>
Date: Wed, 06 Jul 2011 08:50:43 +0200
From: Peter Kruse <pk@q-leap.de>
Organization: Q-Leap Networks GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
References: <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com> <4DA54D2A.3050206@q-leap.de> <alpine.DEB.2.00.1104131116330.19493@router.home> <4E09BEA1.1080501@q-leap.de> <alpine.DEB.2.00.1107051013500.16869@router.home> <20110705172043.GA15147@csn.ul.ie> <20110706041602.GX1026@dastard>
In-Reply-To: <20110706041602.GX1026@dastard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

thanks for looking into this!

On 07/05/2011 07:20 PM, Mel Gorman wrote:
> There are also patches that should be in 2.6.32.29 like [e52af507:
> xfs: Non-blocking inode locking in IO completion] which talks
> about deadlocks during IO completion but the kernel name is
> 2.6.32.29-ql-server-20. Does that include this patch or is it some
> other fork?

it's not really a fork, we basically give the kernel a name.

Ok then I think we will schedule a kernel update and if the
server then runs for more than 40 days we could say that
the problem is fixed.

all the best,

  Peter
