Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab0JFOxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:53:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60048 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab0JFOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:53:33 -0400
Message-ID: <4CAC8D5D.9000303@vflare.org>
Date: Wed, 06 Oct 2010 10:53:17 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOM panics with zram
References: <1281374816-904-1-git-send-email-ngupta@vflare.org> <1284053081.7586.7910.camel@nimitz> <4CA8CE45.9040207@vflare.org> <20101005234300.GA14396@kroah.com> <4CABDF0E.3050400@vflare.org> <20101006023624.GA27685@kroah.com> <4CABFB6F.2070800@vflare.org> <AANLkTi=0bPudtyVzebvM0hZUB6DdDhjopB06FOww8hvt@mail.gmail.com> <20101006140343.GC19470@kroah.com> <4CAC84CF.3060902@kernel.org>
In-Reply-To: <4CAC84CF.3060902@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/2010 10:16 AM, Pekka Enberg wrote:
>  On 6.10.2010 17.03, Greg KH wrote:
>> Oops, I need to update the MAINTAINERS file, the proper place for the
>> staging tree is now in git, at
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>>
>> which feeds directly into the linux-next tree.
> 
> Excellent! Nitin, can you develop and test zram against this tree?
> 

This seems like the ideal tree to develop against.

Thanks!
Nitin
