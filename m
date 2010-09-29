Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0I2NQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:16:48 -0400
Received: from kroah.org ([198.145.64.141]:43738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab0I2NQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:16:47 -0400
Date: Wed, 29 Sep 2010 05:37:52 -0700
From: Greg KH <greg@kroah.com>
To: Avi Kivity <avi@redhat.com>
Cc: Robin Holt <holt@sgi.com>, Nathan Fontenot <nfont@austin.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@ozlabs.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] v2 De-Couple sysfs memory directories from memory
	sections
Message-ID: <20100929123752.GA18865@kroah.com>
References: <4CA0EBEB.1030204@austin.ibm.com> <4CA1E338.6070201@redhat.com> <20100928151218.GJ14068@sgi.com> <20100929025035.GA13096@kroah.com> <4CA2F9A2.3090202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA2F9A2.3090202@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:32:34AM +0200, Avi Kivity wrote:
>  On 09/29/2010 04:50 AM, Greg KH wrote:
>> >
>> >  Because the old ABI creates 129,000+ entries inside
>> >  /sys/devices/system/memory with their associated links from
>> >  /sys/devices/system/node/node*/ back to those directory entries.
>> >
>> >  Thankfully things like rpm, hald, and other miscellaneous commands scan
>> >  that information.
>>
>> Really?  Why?  Why would rpm care about this?  hald is dead now so we
>> don't need to worry about that anymore,
>
> That's not what compatiblity means.  We can't just support 
> latest-and-greatest userspace on latest-and-greatest kernels.

Oh, I know that, that's not what I was getting at at all here, sorry if
it came across that way.

I wanted to know so we could go fix programs that are mucking around in
these files, as odds are, the shouldn't be doing that in the first
place.

Like rpm, why would it matter what the memory in the system looks like?

thanks,

greg k-h
