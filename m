Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab1J0WeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:34:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60540 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab1J0WeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:34:12 -0400
Message-ID: <4EA9DC53.8020907@linux.vnet.ibm.com>
Date: Thu, 27 Oct 2011 17:33:55 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
In-Reply-To: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11102722-3534-0000-0000-000000F93F25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 01:52 PM, Dan Magenheimer wrote:
> Hi Linus --
> 
> Frontswap now has FOUR users: Two already merged in-tree (zcache
> and Xen) and two still in development but in public git trees
> (RAMster and KVM).  Frontswap is part 2 of 2 of the core kernel
> changes required to support transcendent memory; part 1 was cleancache
> which you merged at 3.0 (and which now has FIVE users).

We are also actively looking at utilizing frontswap for IBM Power and would
welcome its inclusion in mainline.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


