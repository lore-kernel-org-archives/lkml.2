Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1IESJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:09:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:34208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1IESJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:09:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45432940"
From: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 5 Sep 2011 23:38:49 +0530
Subject: RE: Player Thread is not woken after period elapsed
Thread-Topic: Player Thread is not woken after period elapsed
Thread-Index: Acxr9C8qgPHrHXm6QSKfJMr03WdrtwAAjLCQ
Message-ID: <3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
 <20110905105253.2787b91f@infradead.org>
In-Reply-To: <20110905105253.2787b91f@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I have not provided the kernel version. Kernel version is 2.6.35. 
However, wait_for_avail() does not have the code similar to the one provided in the patch below. I will give a try. 

-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Monday, September 05, 2011 11:23 PM
To: Nallasellan, Singaravelan
Cc: alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
Subject: Re: Player Thread is not woken after period elapsed

On Mon, 5 Sep 2011 23:08:53 +0530
"Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com> wrote:

> Hi,
> 
> When I tried to root cause a glitch in the audio playback, I found a 
> weird behavior.
> 
> User thread which invokes the writei function which in turn  invokes a 
> kernel function which waits for the free buffer to write the audio 
> data.  This kernel function adds this thread to a wake(sleep) queue 
> and calls a schedule_timeout (msecs_to_jiffies(10000)).

actually it doesn't... you must be on some really really old kernel or something.


> 
> Will you provide some hint on how to go about identifying the root 
> cause?

https://lkml.org/lkml/2011/9/5/201



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, visit http://www.lesswatts.org
