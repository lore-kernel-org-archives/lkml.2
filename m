Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab0JFOQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:16:50 -0400
Received: from freeflow.nu ([178.79.134.28]:33510 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab0JFOQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:16:49 -0400
Message-ID: <4CAC84CF.3060902@kernel.org>
Date: Wed, 06 Oct 2010 17:16:47 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Nitin Gupta <ngupta@vflare.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOM panics with zram
References: <1281374816-904-1-git-send-email-ngupta@vflare.org> <1284053081.7586.7910.camel@nimitz> <4CA8CE45.9040207@vflare.org> <20101005234300.GA14396@kroah.com> <4CABDF0E.3050400@vflare.org> <20101006023624.GA27685@kroah.com> <4CABFB6F.2070800@vflare.org> <AANLkTi=0bPudtyVzebvM0hZUB6DdDhjopB06FOww8hvt@mail.gmail.com> <20101006140343.GC19470@kroah.com>
In-Reply-To: <20101006140343.GC19470@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 6.10.2010 17.03, Greg KH wrote:
> Oops, I need to update the MAINTAINERS file, the proper place for the
> staging tree is now in git, at
>
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>
> which feeds directly into the linux-next tree.

Excellent! Nitin, can you develop and test zram against this tree?

             Pekka
