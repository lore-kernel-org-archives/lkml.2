Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1IPRqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:46:46 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:51078 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1IPRqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:46:45 -0400
Message-ID: <4E738B81.2070005@vflare.org>
Date: Fri, 16 Sep 2011 13:46:41 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg KH <greg@kroah.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
        dan.magenheimer@oracle.com, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        linux-mm@kvack.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org> <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org> <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org> <4E72284B.2040907@linux.vnet.ibm.com>
In-Reply-To: <4E72284B.2040907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On 09/15/2011 12:31 PM, Seth Jennings wrote:

> 
> So this is how I see things...
> 
> Right now xvmalloc is broken for zcache's application because
> of its huge fragmentation for half the valid allocation sizes
> (> PAGE_SIZE/2).
> 
> My xcfmalloc patches are _a_ solution that is ready now.  Sure,
> it doesn't so compaction yet, and it has some metadata overhead.
> So it's not "ideal" (if there is such I thing). But it does fix
> the brokenness of xvmalloc for zcache's application.
> 
> So I see two ways going forward:
> 
> 1) We review and integrate xcfmalloc now.  Then, when you are
> done with your allocator, we can run them side by side and see
> which is better by numbers.  If yours is better, you'll get no
> argument from me and we can replace xcfmalloc with yours.
> 
> 2) We can agree on a date (sooner rather than later) by which your
> allocator will be completed.  At that time we can compare them and
> integrate the best one by the numbers.
> 


I think replacing allocator every few weeks isn't a good idea. So, I
guess better would be to let me work for about 2 weeks and try the slab
based approach.  If nothing works out in this time, then maybe xcfmalloc
can be integrated after further testing.

Thanks,
Nitin
