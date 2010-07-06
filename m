Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0GFPUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:20:36 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60610 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0GFPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:20:35 -0400
Message-ID: <4C3349BF.7030104@austin.ibm.com>
Date: Tue, 06 Jul 2010 10:20:31 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Greg KH <gregkh@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
References: <20100628154455.GA13918@suse.de>	 <1277769867.8354.531.camel@nimitz>	 <20100629115232.38BC.A69D9226@jp.fujitsu.com>	 <1277827384.8354.3413.camel@nimitz>	<20100629180415.GB1240@suse.de>	 <20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>	 <20100630154755.GB12158@suse.de>	 <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com> <1277990595.8354.10356.camel@nimitz>
In-Reply-To: <1277990595.8354.10356.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 08:23 AM, Dave Hansen wrote:
> 
> I was thinking more along the lines of just taking adjacent sections and
> merging them.  We'll need a new "end address" or size file.  Maybe
> "end_phys_index" or something similar.
> 
> Such a beast would not fix all of the pathological cases, like where
> only every other 16MB section is populated with RAM, but I don't think
> those are very common at all, especially in cases where there's a lot of
> RAM.  But, it also has a chance of being relatively backward-compatible.
> In most cases, we may even be able to calculate a new phys_block_size
> where everything fits evenly and be fully backward-compatible with the
> old ABI.
> 

Under this scenario were you thinking that all of the memory sections that
reside under this memory block would then be acted upon as a whole.  For
example would we allow users to hotplug individual memory sections included
in th block, or would the memory block be acted upon as a whole?

-Nathan
