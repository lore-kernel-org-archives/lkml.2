Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0FYJTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:19:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49777 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0FYJTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:19:15 -0400
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug disable boot option
References: <4C24012B.9030506@austin.ibm.com>
	<20100625105340.803C.A69D9226@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 11:19:13 +0200
In-Reply-To: <20100625105340.803C.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Fri, 25 Jun 2010 11:04:19 +0900 (JST)")
Message-ID: <87d3vfeage.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

>> Proposed patch to disable memory hotplug via a boot option,
>> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
>> prevents the creation of the memory sysfs directories for memory sections.
>> 
>> This patch is meant to help alleviate very long boot times on systems with
>> large memory (1+ TB) and many memory sections (10's of thousands).
>
> Why making simple /sys file is so slowly? Couldn't we fix such performance
> problem?

Yes I agree this really needs to be fixed properly, not hacked around
with an option. Nathan can you please post some profile logs of the long
boot times?  

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
