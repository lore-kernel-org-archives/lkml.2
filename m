Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab0I0OW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:22:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab0I0OW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:22:27 -0400
Date: Mon, 27 Sep 2010 10:21:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
Message-ID: <20100927142149.GV26290@redhat.com>
References: <4C03C608.1040600@gmail.com>
 <20100601135004.GP15159@redhat.com>
 <4C051D44.7040203@gmail.com>
 <20100602184459.GA15159@redhat.com>
 <4C0B3E94.6020506@gmail.com>
 <4C80B338.6020701@gmail.com>
 <20100903135613.GV4879@redhat.com>
 <4C9CBF4A.9060302@gmail.com>
 <20100924191946.GS26290@redhat.com>
 <4C9E4DDB.6070503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9E4DDB.6070503@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 10:30:35PM +0300, Jiri Slaby wrote:
> On 09/24/2010 10:19 PM, Don Zickus wrote:
> > Actually there seems to have been some clean up in the cpu hotplug error
> > handling code.  Could you remove that snippet of code and see if the
> > problem still happens?
> 
> The thing is I don't remember what problems exactly I had. From the
> description I wrote, I cannot reproduce it anymore :).
> 
> thanks for looking into that,

ok. :-)  Let me know if it pops up again.

Cheers,
Don
