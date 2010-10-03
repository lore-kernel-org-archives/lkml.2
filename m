Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0JCHxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 03:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab0JCHxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 03:53:11 -0400
Message-ID: <4CA83651.1010502@redhat.com>
Date: Sun, 03 Oct 2010 09:52:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Robin Holt <holt@sgi.com>, Nathan Fontenot <nfont@austin.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@ozlabs.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] v2 De-Couple sysfs memory directories from memory
 sections
References: <4CA0EBEB.1030204@austin.ibm.com> <4CA1E338.6070201@redhat.com> <20100928151218.GJ14068@sgi.com> <20100929025035.GA13096@kroah.com> <4CA2F9A2.3090202@redhat.com> <20100929123752.GA18865@kroah.com>
In-Reply-To: <20100929123752.GA18865@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/29/2010 02:37 PM, Greg KH wrote:
> >>  >   Thankfully things like rpm, hald, and other miscellaneous commands scan
> >>  >   that information.
> >>
> >>  Really?  Why?  Why would rpm care about this?  hald is dead now so we
> >>  don't need to worry about that anymore,
> >
> >  That's not what compatiblity means.  We can't just support
> >  latest-and-greatest userspace on latest-and-greatest kernels.
>
> Oh, I know that, that's not what I was getting at at all here, sorry if
> it came across that way.
>
> I wanted to know so we could go fix programs that are mucking around in
> these files, as odds are, the shouldn't be doing that in the first
> place.
>
> Like rpm, why would it matter what the memory in the system looks like?
>

I see, thanks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

